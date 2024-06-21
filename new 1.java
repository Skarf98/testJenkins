public class CasePDFGenerate{
    
    public Case caseRecord{get;set;}
  
    public CasePDFGenerate(){}
    

    @AuraEnabled(cacheable=true) 
        public static Case tCase(Id recordId) { 
            
            Case cs = [SELECT Id,CaseNumber FROM Case WHERE Id=:recordId];
            return cs;
       } 
}
