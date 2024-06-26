public class JKbusinessCasePdfGenerate{
    public JKBusinessCase__c businessCaseRecord{get;set;}
    public boolean recordType {get;set;}
    public boolean status {get;set;}
    public boolean readiness {get;set;}
    public JKbusinessCasePdfGenerate(){
        
        string bcRecordID = ApexPages.currentPage().getParameters().get('bcID');
        System.debug('@@ business case ID-->' + bcRecordID);
        

        businessCaseRecord = new JKBusinessCase__c();
        
        //Check in the parameter exists
        if(bcRecordID!=null && bcRecordID!=''){
            businessCaseRecord=[SELECT id, Name, JKFamily__c,JKPenetrationRate__c, JKPersonalizationLevel__c,
                                           JKContentDescription__c, JKEA_PP__c, JKStatus__c, JKStatusApprovalB__c,
                                           JKRetailPriceWOVATLF2__c, JKInvoicePriceLF2__c, JKReadiness__c,
                                           JKContributionMarginPercLF2__c, JKROSLF2__c, JKClosedDateB__c, JKClosedDateA__c,
                                           JKTotalTurnoverLF2__c, JKRelease__c, JKZP8__c,
                                           JKCommentsRetailPriceLF2__c, JKCloseDateAText__c,
                                           JKCloseDateBText__c, JKPartNumber__c, JKVehicle__c, RecordType.Name
                                FROM JKBusinessCase__c WHERE id=:bcRecordID];
        }
        
       recordType = businessCaseRecord.RecordType.Name  == 'One Shot'? true : false;
       status = businessCaseRecord.JKStatus__c == 'closed' && businessCaseRecord.JKReadiness__c !='readiness status: ok' ? true: false;
       readiness = businessCaseRecord.JKStatus__c == 'closed' && businessCaseRecord.JKReadiness__c=='readiness status: ok'? true: false;
    }
    @future(callout=true)
    public static void createPdf(List<Id> bcLst, string title){
        system.debug('@@ create PDF id->'+ bcLst);
        List<Attachment> lstAttachment = new List<Attachment>();
        for(id bsc: bcLst){
            PageReference page = new PageReference('/apex/PdfGenerate?bcID=' + bsc);
            Blob pdf;
            String name = '';
            String descr = 'BusinessCase PDF';
            try{
                pdf = page.getContentAsPDF();
                system.debug('@@ SAVE');
            }catch(Exception e){
                pdf = Blob.valueOf(e.getMessage());
                descr = e.getMessage();
                system.debug('@@ ERROR');
            }
            Attachment att = new Attachment();
            att.Body = pdf;
            att.Name = title+'.pdf';
            att.IsPrivate = false;
            att.ParentId = bsc;
            att.Description = descr;
            lstAttachment.add(att);
        }
        insert lstAttachment;
        system.debug('@@ INSERT');
    }
}