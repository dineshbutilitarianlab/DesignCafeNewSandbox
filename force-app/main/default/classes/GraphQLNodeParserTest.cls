@IsTest
public class GraphQLNodeParserTest {
	
    @testSetup
    public static void dataSetup() {
        
    }
    
    @isTest
    public static void testMethod1() {
    	
        Test.startTest();
        
        List<String> fields = new List<String>();
        
        GraphQLNodeParser obj = new GraphQLNodeParser();
        
        GraphQLNode obj2 = new GraphQLNode('TEST');
        obj.parse(obj2, 1, true);
        Test.stopTest();
        
    }
    
}