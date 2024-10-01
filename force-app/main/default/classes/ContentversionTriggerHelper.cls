public with sharing class ContentversionTriggerHelper {
    public static void onAfterInsert(List<ContentVersion> cvList) {
        List<Id> contentDocumentIds = new List<Id>();
        Map<Id, Id> cvAndCdMap = new Map<Id,Id>();
        Map<Id, Id> cdAndCdlMap = new Map<Id,Id>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        Map<Id, Id> opportunityIdAndCdMap = new Map<Id,Id>();
        for (ContentVersion cv:cvList) {
            contentDocumentIds.add(cv.ContentDocumentId);
            cvAndCdMap.put(cv.Id, cv.ContentDocumentId);
        }
        if (contentDocumentIds.size() > 0) {
            cdlList = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :contentDocumentIds];
            for (ContentDocumentLink cdLink : cdlList) {
                if (cdLink.LinkedEntityId != null) {
                    if ('Opportunity' == cdLink.LinkedEntityId.getSObjectType().getDescribe().getName()) {
                        cdAndCdlMap.put(cdLink.ContentDocumentId, cdLink.LinkedEntityId);
                    }
                }
            }

            List<ContentDocument> cdList = [SELECT Id FROM ContentDocument WHERE Id IN :cdAndCdlMap.keySet()];

            for (ContentDocument cd : [SELECT Id FROM ContentDocument WHERE Id IN :cdAndCdlMap.keySet() ORDER BY CREATEDDATE DESC]) {
                Id opportunityId = cdAndCdlMap.get(cd.Id);
                if (!opportunityIdAndCdMap.keySet().contains(opportunityId)) {
                    opportunityIdAndCdMap.put(opportunityId, cd.Id);
                    UploadPaymentDoc.uploadFile(opportunityId, cd.Id);
                }
            }
        }
    }
}