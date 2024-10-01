@isTest
public class GraphQLRequestTest {

    @testSetup
    public static void dataSetup() {
        
    }
    
    @isTest
    public static void testMethod1() {
        
        Test.startTest();
        
        GraphQLQueryNode obj2 = new GraphQLQueryNode('TEST');
        GraphQLRequest obj = new GraphQLRequest(obj2);
        
        obj = new GraphQLRequest('TEST');
        
        obj.withHeader('KEY', 'VAL');
        
        Map<String, String> headers = new Map<String, String>();
        obj.withHeaders(headers);
        
        Map<String, Object> variables = new Map<String, Object>();
        obj.withVariable('KEY', 'VAL');
        obj.withVariables(variables);

        obj.toString();
        obj.toString(true);
        
        Test.stopTest();   
    }
}