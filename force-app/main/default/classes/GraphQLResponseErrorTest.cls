@isTest
public class GraphQLResponseErrorTest {

    @testSetup
    public static void dataSetup() {
        
    }
    
    @isTest
    public static void testMethod1() {
        
        Test.startTest();
        
        new GraphQLResponseError('TEST');
        
        List<Map<String, Object>> res = new List<Map<String, Object>>();
        Map<String, Object> res1 = new Map<String, Object>();
        
        List<Map<String, Object>> locs = new List<Map<String, Object>>();
        Map<String, Object> loc = new Map<String, Object>();
        loc.put('line', 1);
        loc.put('column', 2);
        locs.add(loc);
        
        res1.put('message', 'MSG');
        res1.put('locations', locs);
        res1.put('path', new List<Object>());
        res1.put('extensions', new Map<String, Object>());
        res.add(res1);
        GraphQLResponseError.parseErrors(res);
                
        Test.stopTest();
    }   
}