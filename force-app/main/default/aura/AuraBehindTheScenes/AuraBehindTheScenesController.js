({
    onTabCreated: function(component, event) {
        //define workspaceAPI variable and newtabid variable from event
        var workspace = component.find("workspace");              
        var newTabId = event.getParam('tabId');
        //get tabinfo based on tabid
        workspace.getTabInfo({
            tabId: newTabId
        }).then(function (tabInfo) {        
            //get recordid from tabinfo
            var recordId = tabInfo.recordId;  
            //check to see if new tab is a case record
            if(recordId.substring(0,3) == '500'){
                //call apex method to return the child object api name and record id of child detail record based on case record id
                var action = component.get("c.getObjectAndRecord");                
                action.setParams({ recordId : recordId });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        //set variables based on response from apex method
                        var responseVal = response.getReturnValue();                        
                        var objectname = responseVal.objectName;
                        var objectRecordid = responseVal.recordId;
                        //open subtab for child detail object and set in focus
                        workspace.openSubtab({
                            parentTabId: newTabId,
                            url: '/lightning/r/' + objectname + '/' + objectRecordid + '/view',                            
                            focus: true
                        });
                    }
                });
                $A.enqueueAction(action);  
            }
        });
    }
})