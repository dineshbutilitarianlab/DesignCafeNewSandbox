@IsTest
public class GraphQLDirectiveTest {

    @testSetup
    public static void dataSetup() {
        
    }
    
    @isTest
    public static void testMethod1() {
        
        Test.startTest();
        GraphQLDirective obj = new GraphQLDirective(GraphQLDirectiveType.Include, 'TEST');
        obj = new GraphQLDirective(GraphQLDirectiveType.Include, false);
        obj.parse(null, false);
        Test.stopTest();
    }
}