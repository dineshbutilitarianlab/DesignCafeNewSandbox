({
	helperMethod : function() {
		
	},
    deleteDocs : function(cmp,event){
        const allAttachedFiles = cmp.get("v.sObjectAttachedFiles");//use this later to filter out the ids which were removed.
        const docIdToDelete =event.getSource().get("v.value");
        if(allAttachedFiles && allAttachedFiles.length>0){
            const filteredIds = allAttachedFiles.filter(file=>file.Id != docIdToDelete); //will hold the fileId/documentId which were not removed.
            if(filteredIds && filteredIds !=null){
                cmp.set("v.sObjectAttachedFiles",filteredIds); //finally setting the values which were left after removing the documents. This would be used for inserting/updating the contentdocument
             }            
        }
        
    }
})