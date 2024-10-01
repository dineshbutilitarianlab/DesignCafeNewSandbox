@IsTest
public class GraphQLNodeTest {
	
    @testSetup
    public static void dataSetup() {
        
    }
    
    @isTest
    public static void testMethod1() {
    	
        Test.startTest();
        
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        List<String> fields = new List<String>();
            
		new GraphQLNode();  
        new GraphQLNode(nodes);  
        new GraphQLNode(fields);  
        new GraphQLNode('TEST', nodes);  
        GraphQLNode obj = new GraphQLNode('TEST', fields);  
        
        obj.byAlias('TEST');
        
        obj.withField('TEST');
        obj.withFields(fields);
        obj.withNode(new GraphQLNode());
        obj.withNodes(nodes);
                
        List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode>();
        obj.withFragment('TEST');
        obj.withFragments(fields);
		obj.withArgument('TEST', null);
        
        List<GraphQLArgument> arguments = new List<GraphQLArgument>();
        obj.withArguments(arguments);
        
        obj.includeIf(false);
        obj.includeIf('TEST');
        obj.skipIf(false);
        obj.skipIf('TEST');
        
        obj.asQuery();
        obj.asMutation();
        obj.asSubscription();
        obj.getParser();
        
        obj.hasArguments();
        obj.hasDirectives();
        
        Test.stopTest();
    }
}