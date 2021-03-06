({
	getTotalSprintsAura : function(component, event, helper) {
		var helper = this;
		var sprintData = component.get('v.sprintData');
		if (!sprintData) {
			console.log('!sprintData');
			return;
		}
		var teamId = sprintData.sprintInfo.Scrum_Team__c;

		var action = component.get("c.getTotalSprintsAura");

		action.setParams({
			"teamId": teamId
		});

		action.setCallback(this, function(response) {
			var state = response.getState();

			if (state === "SUCCESS"){
				if (component.isValid()) {
					var totalSprints = JSON.parse(response.getReturnValue());
					component.set('v.totalSprints', totalSprints);
					component.set('v.sprintOptionSelected', totalSprints.toString());
					helper.updateSprintOptions(component, event, helper);
					helper.getCurrSprintsAura(component, event, helper);
				}
			} else {
				if (component.isValid()) {
					helper.displayErrorMessage(component, event, helper);

					console.error("The call to getTotalSprintsAura failed with errors. See below.");
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.error("Error message: " + errors[0].message);
						}
					} else {
						console.error("Unknown error");
					}
				}
			}
		});

		$A.enqueueAction(action);
	},
	getCurrSprintsAura: function(component, event, helper) {
		var sprintData = component.get('v.sprintData');
		var sprintOptionSelected = component.get('v.sprintOptionSelected')
		var teamId = sprintData.sprintInfo.Scrum_Team__c;
		var action = component.get("c.getCurrSprintsAura");
		
		action.setParams({
			"teamId": teamId,
			"numberSprints": sprintOptionSelected
		});

		action.setCallback(this, function(response) {
			var state = response.getState();

			if (state === "SUCCESS"){
				if (component.isValid()) {
					var returnValue = JSON.parse(response.getReturnValue());
                    //Serialize the chart data here and remove the namespace
                    var nameSpace = sprintData.nameSpace;
                    for(property in returnValue){
                     returnValue = helper.serializeValuesForNamespace(returnValue,property,helper,nameSpace);
                	}
                    
					returnValue.reverse(); // sprints come back as most recent first. This makes most recent last.
					component.set('v.currSprints', returnValue);
					component.set('v.sprintOptionSelected', returnValue.length.toString());
					helper.updateSprintVelocityChart(component, event, helper);
				}
			} else {
				if (component.isValid()) {
					helper.displayErrorMessage(component, event, helper);

					console.error("The call to getCurrSprintsAura failed with errors. See below.");
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.error("Error message: " + errors[0].message);
						}
					} else {
						console.error("Unknown error");
					}
				}
			}
		});

		$A.enqueueAction(action);
	},
    
    serializeValuesForNamespace:function(chartData,currentNode,helper,nameSpace){
        if(nameSpace!=null && nameSpace!=''){
            if(typeof chartData[currentNode] != 'object'){
                chartData[currentNode.replace(nameSpace, '')] = chartData[currentNode];
            }
            else{
                chartData[currentNode.replace(nameSpace, '')] = chartData[currentNode];
                for(innerNode in chartData[currentNode]){
                    chartData[currentNode] = helper.serializeValuesForNamespace(chartData[currentNode],innerNode,helper,nameSpace);
                }
            }
        }
        return chartData;
    },
    
	updateSprintVelocityChart: function(component, event, helper) {
		var currSprints = component.get('v.currSprints');
		var endDates = currSprints.map(function(sprint) {
			return sprint.End_Date__c
		});
		var completedPoints = currSprints.map(function(sprint) {
			return sprint.Completed_Story_Points__c
		});
		var totalCompletedPoints = completedPoints.reduce(function(acc, curr) {
			return acc + curr;
		}, 0);
		var avgVelocity = parseInt((totalCompletedPoints / currSprints.length), 10);
		var avgVelocityPoints = [];
		for (var i = 0, len = currSprints.length; i < len; i++) {
			avgVelocityPoints.push(avgVelocity);
		}

		if (currSprints && endDates && completedPoints) {
			component.set('v.dataAndOptions', {
				data: {
					labels: endDates,
					datasets: [
						{
							label: 'Points Completed',
							data: completedPoints,
							borderColor: "rgba(0, 112, 210, 1)",
							backgroundColor: "rgba(0, 112, 210, 0.2)",
							fill: true,
							pointRadius: 0,
							borderWidth: 3,
							pointHitRadius: 5,
							pointHoverRadius: 3,
							pointHoverBackgroundColor: "rgba(0, 112, 210, 1)",
							lineTension: 0
						},
						{
							label: 'Avg Velocity',
							data: avgVelocityPoints,
							borderColor: "rgba(245, 103, 91, 1)",
							backgroundColor: "rgba(245, 103, 91, 0.2)",
							fill: true,
							pointRadius: 0,
							borderWidth: 3,
							pointHitRadius: 5,
							pointHoverRadius: 3,
							pointHoverBackgroundColor: "rgba(245, 103, 91, 1)",
							lineTension: 0
						}
					]
				},
				options: {
					title: {
						display: false
					},
					legend: {
						position: 'bottom'
					},
					scales: {
						yAxes: [{
							ticks: {
								beginAtZero:true
								// , suggestedMax: parseInt(idealBurndown.data[0], 10) + 1 // ensures that biggest y-value isn't top y-axis value
							},
							gridLines: {
								display: false
							}
						}],
						xAxes: [{
							gridLines: {
								display: false
							},
							ticks: { // have to do this b/c there's a bug in 2.1.4 which adds white space on the left of the chart (explained here: https://github.com/chartjs/Chart.js/issues/2684)
								maxRotation: 90,
								minRotation: 90
							}
						}]
					}
				}
			});
			helper.displayChart(component, event, helper);
		}
	},
	updateSprintOptions: function(component, event, helper) {
		var totalSprints = component.get('v.totalSprints');
		var sprintOptionSelected = component.get('v.sprintOptionSelected');
		var sprintOptionSelectedNum = parseInt(sprintOptionSelected, 10);
		var sprintOptions = [];

		for (var i = 2; i <= totalSprints; i++) {
			sprintOptions.push({value: i, label: i, selected: i == sprintOptionSelectedNum});
		};
		sprintOptions.reverse();

		component.set('v.sprintOptions', sprintOptions);
	}
})