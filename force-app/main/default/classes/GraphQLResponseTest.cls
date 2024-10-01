@isTest
public class GraphQLResponseTest {

    @testSetup
    public static void dataSetup() {
        
    }
    
    @isTest
    public static void testMethod1() {
        
        Test.startTest();
        
        GraphQLResponseError err = new GraphQLResponseError('TEST');
        Map<String, Object> responseJson = new Map<String, Object>();
        responseJson.put('errors', null);
        
        GraphQLResponse obj = new GraphQLResponse(err);
		
        Type t1 = Account.class;
        Map<String, String> obj2 = new Map<String, String>();
        obj.getDataAs(t1);
        GraphQLResponse.parse(JSON.serialize(responseJson));
        
        obj.hasErrors();
        obj.hasData();
        obj.getErrors();
        obj.getData();
        obj.getDataNode('TEST');
        
        obj.getDataNodeAs('TEST', t1);
        Test.stopTest();
    }
}