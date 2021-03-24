public class BehindTheScenesApexController {
    @AuraEnabled 
    public static Map<String, String> getObjectAndRecord(String recordId){      
        //Query for casetype based on case record id  
        Case myCase = [SELECT Id, RecordType.DeveloperName from Case where Id = :recordId];
        String caseTypeName = myCase.RecordType.DeveloperName;
        Case_Detail_Object_Mapping__mdt mappingrecord = [Select Case_Detail_Object_Name__c,
                                                        		Case_Type_Name__c,
                                                        		Relationship_Field_Name__c 
                                                        	FROM Case_Detail_Object_Mapping__mdt
                                                            WHERE Case_Type_Name__c = :caseTypeName];  
        //Get detail object name and relatiionship field name from custom metadata type based on case type from case record                                                                          
        String objectName = mappingrecord.Case_Detail_Object_Name__c;
        String relationshipFieldName = mappingrecord.Relationship_Field_Name__c;
        //Query for detail object record
        String queryString = 'SELECT Id FROM ' + objectName + ' WHERE ' + relationshipFieldName + ' = \'' + recordId + '\' LIMIT 1';
        //Pass record Id and objectname in response map
		List<sObject> myObjList = Database.query(queryString);        
        Map<String, String> retMap = new Map<String, String>();
        retMap.put('recordId',myObjList[0].Id);
        retMap.put('objectName',objectName);
        return retMap;
    }
}