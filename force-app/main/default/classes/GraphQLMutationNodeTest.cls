@IsTest
public class GraphQLMutationNodeTest {
	
    @testSetup
    public static void dataSetup() {
        
    }
    
    @isTest
    public static void testMethod1() {
    	
        Test.startTest();
        GraphQLMutationNode obj = new GraphQLMutationNode();
        
        obj = new GraphQLMutationNode('TEST');
        
        obj = new GraphQLMutationNode(new GraphQLNode());
        obj = new GraphQLMutationNode('TEST', new GraphQLNode());
        
        List<String> fields = new List<String>();
        obj = new GraphQLMutationNode(fields);
        
        List<GraphQLNode> nodes = new List<GraphQLNode>();
        obj = new GraphQLMutationNode(nodes);
        
        obj = new GraphQLMutationNode('TEST', fields);
        obj = new GraphQLMutationNode('TEST', nodes);
        
        obj.withField('TEST');
        obj.withFields(fields);
        obj.withNode(new GraphQLNode());
        obj.withNodes(nodes);
        
        obj.withFragment(new GraphQLFragmentNode('TEST', 'TEST'));
        
        List<GraphQLFragmentNode> fragments = new List<GraphQLFragmentNode>();
        obj.withFragments(fragments);
        
        obj.withVariable('TEST', 'TEST');
        
        obj.buildRequest();
        
        obj.getOperation();
        
        Test.stopTest();
    }
}