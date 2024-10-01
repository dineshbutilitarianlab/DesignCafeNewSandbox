@isTest
public class GraphQLQueryNode_test {
    @isTest
    public static void GraphQLQueryNodetest(){
        GraphQLNode node = new GraphQLNode();
        List<GraphQLFragmentNode> GraphQLFragmentList = new List<GraphQLFragmentNode>();  
        List<GraphQLNode> nodeList = new List<GraphQLNode>();
        nodeList.add(node);
        List<String> strList = new List<String>();
        GraphQLQueryNode node0 = new GraphQLQueryNode();
        GraphQLQueryNode node1 = new GraphQLQueryNode('name');
        GraphQLQueryNode node2 = new GraphQLQueryNode(node);
        GraphQLQueryNode node3 = new GraphQLQueryNode(strList);
        GraphQLQueryNode node4 = new GraphQLQueryNode(nodeList);
        GraphQLQueryNode node5 = new GraphQLQueryNode('name',node);
        GraphQLQueryNode node6 = new GraphQLQueryNode('name',strList);
        GraphQLQueryNode node7 = new GraphQLQueryNode('name',nodeList)
            .withField('name')
            .withFields(strList)
            .withNode(node)
            .withNodes(nodeList)
            .withFragments(GraphQLFragmentList)
            .withVariable('name','name');
            node7.buildRequest();
            node7.getOperation();
    }

}