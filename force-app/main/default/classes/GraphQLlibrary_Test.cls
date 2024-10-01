@isTest
public class GraphQLlibrary_Test {

@isTest
    public static void graphQLlib()
    {
        GraphQLNode node = new GraphQLNode();
        List<GraphQLNode> nodeList = new List<GraphQLNode>();
        nodeList.add(node);
        List<String> strList = new List<String>();
        GraphQLFragmentNode node1 = new GraphQLFragmentNode('name', 'type');
        GraphQLFragmentNode node2 = new GraphQLFragmentNode('name', 'type', nodeList);
        GraphQLFragmentNode node3 = new GraphQLFragmentNode('name', 'type', strList);
        GraphQLFragmentNode node4 = new GraphQLFragmentNode('name', 'type', nodeList, strList);
        GraphQLFragmentNode node5 = new GraphQLFragmentNode('name', 'type')
            .withField('field')
            .withFields(strList)
            .withNode(node)
            .withNodes(nodeList)
            .withFragment('fragment')
            .withFragments(strList);
        
        GraphQLFragmentNodeParser obj = new GraphQLFragmentNodeParser();
        obj.parse(node4, 1, true);
		
    }
}