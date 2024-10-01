@isTest
public class graphQL_library_test2 {

    @isTest
    public static void graphQLlibTest()
    { 
        GraphQLNode node = new GraphQLNode();
        List<GraphQLFragmentNode> GraphQLFragmentList = new List<GraphQLFragmentNode>();    
        List<GraphQLNode> nodeList = new List<GraphQLNode>();
        nodeList.add(node);
        List<String> strList = new List<String>();
        GraphQLSubscriptionNode node0 = new GraphQLSubscriptionNode();
        GraphQLSubscriptionNode node1 = new GraphQLSubscriptionNode('name');
        GraphQLSubscriptionNode node2 = new GraphQLSubscriptionNode(node);
        GraphQLSubscriptionNode node3 = new GraphQLSubscriptionNode(strList);
        GraphQLSubscriptionNode node4 = new GraphQLSubscriptionNode(nodeList);
        GraphQLSubscriptionNode node5 = new GraphQLSubscriptionNode('name', node);
        GraphQLSubscriptionNode node6 = new GraphQLSubscriptionNode('name', node);
        GraphQLSubscriptionNode node7 = new GraphQLSubscriptionNode('name', nodeList)
            .withField('name')
            .withFields(strList)
            .withNode(node)
            .withNodes(nodeList)
            .withFragments(GraphQLFragmentList)
            .withVariable('name','name');
            node7.getOperation();
    }


}