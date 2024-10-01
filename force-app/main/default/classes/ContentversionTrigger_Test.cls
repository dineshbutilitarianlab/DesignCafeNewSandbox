@isTest
public class ContentversionTrigger_Test {
      private static ContentVersion createContentVersion(String title, String path, String content) {
        ContentVersion cv = new ContentVersion();
        cv.Title = title;
        cv.PathOnClient = path;
        cv.VersionData = Blob.valueOf(content);
        return cv;
    }
     @IsTest
    static void testContentVersionAfterInsert() {
        // Create a ContentVersion record
        ContentVersion cv = createContentVersion('Test File', 'TestFile.txt', 'This is a test file.');
        
        Test.startTest();
        insert cv;
        Test.stopTest();
    

}
    @isTest
    static void testContentVersionAfterUpdate(){
     ContentVersion cv = createContentVersion('Test File', 'TestFile.txt', 'This is a test file.');
     insert cv;
        
        Test.startTest();
        cv.Title = 'Test File 1';
        update cv;
        Test.stopTest();
    }
}