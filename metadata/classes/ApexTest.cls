public class ApexTest{
    public static String jsonStr = '{ "Id":"a0Ci0000003gniPEAQ",' +
		'"OwnerId" : "005i0000000NsyKAAS", ' +
		'"IsDeleted" : false, ' + 
		'"Name" : "Test", ' +
		'"CreatedDate" : "2013-09-09T23:37:21.000+0000", ' +
		'"CreatedById" : "005i0000000NsyKAAS", ' +
		'"LastModifiedDate" : "2013-09-09T23:37:21.000+0000", ' +
		'"LastModifiedById" : "005i0000000NsyKAAS", ' +
		'"SystemModstamp" : "2013-09-09T23:37:21.000+0000", ' +
		'"LastViewedDate" : "2013-09-09T23:37:21.000+0000", ' +
		'"LastReferencedDate" : "2013-09-09T23:37:21.000+0000" ' +
		'}';
    
    public static void test() {
		Type oType = Type.forName('FollowUps__c');                                           
		sObject rec = (sObject) JSON.deserialize(ApexTest.jsonStr, oType);
        ApexTest.test2();
    }

    public static void test2() {
		Type oType = Type.forName('FollowUps__c'); 
        String listStr = '[' + jsonStr + ',' + jsonStr + ']';
		List<sObject> recs = (List<sObject>) JSON.deserialize(listStr, oType);
    }

}