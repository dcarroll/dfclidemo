public class DataChooserController{

    private String appName { get; set; }
    
    public class TableDescribe {
        public String tableName { get; set; }
        public List<Field> fields { get; set; }
        public Boolean usingTable { get; set; }
        
        public TableDescribe(String tname, List<Field> flds, List<App_Table_Data__c> mytables) {
            fields = flds;
            tableName = tname;
            for (App_Table_Data__c t : mytables) {
                if (t.Name == tableName) {
                    usingTable = true;
                }
            }
        }
    }
    
    private void addSelectedTable() {
        
    }
    
    public PageReference setSelected() {
    	System.debug('tabled selected: ' + selectedTable + ' ' + activeTable.usingTable);
        Boolean found = false;
        for (App_Table_Data__c t : myAppTables) {
            if (t.Name == selectedTable) {
                found = true;
	            if (activeTable.usingTable == false) {
    	            delete t;
        	    }
            }
        }
        if (!found) {
            App_Table_Data__c atd = new App_Table_Data__c();
            atd.Name = selectedTable;
            atd.User_App_Data__c = appId;
            insert atd;
        }
        return null;
    }
    
    public PageReference getFields() {
        System.debug('selected table: ' + selectedTable);
        for (TableDescribe td : meta) {
            if (td.tableName == selectedTable) {
                fields = td.fields;
                activeTable = td;
            }
        }
        return null;
    }
    
    public class Field {
        public String name { get; set; }
        public String ftype { get; set; }
      
        public Field(String fname, String fldtype) {
            name = fname;
            ftype = fldtype;
        }
    }
    
	private TableDescribe activeTable { get; set; }
    private Id appId;
    public List<TableDescribe> meta {get; set; }
    public List<TableDescribe> allTables {get; set; }
    public List<Field> fields { get; set; }
    public String selectedTable { get; set; }
    public Boolean tableSelected { get; set; }
    private User_App_Data__c myapp { get; set; }
    private List<App_Table_Data__c> myAppTables { get; set; }
    private Map<String, App_Table_Data__c> myTablesMap { get; set; }
    
    public DataChooserController() {
        appId = ApexPages.currentPage().getParameters().get('appid');
        myapp = [Select Id, Name From User_App_Data__c Where Id = :appId];
        myAppTables = [Select Id, Name, (Select Id, Name From Table_Field_Data__r) From App_Table_Data__c Where User_App_Data__r.Id = :appId];
        myTablesMap = new Map<String, App_Table_Data__c>();
        if (myAppTables != null) {
            for (App_Table_Data__c t : myAppTables) {
                myTablesMap.put(t.Name, t);
            }
        }
        meta = new List<TableDescribe>();
        allTables = new List<TableDescribe>();
        getUsefulTables();
    }
    
    public void getUsefulTables() {
        List<String> results = new List<String>();
	    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (String key : gd.keyset()) {
            Schema.DescribeSObjectResult r = gd.get(key).getDescribe();
            String objName = r.getName();
            if (r.isAccessible() && r.isCustom()) {
                results.add(objName);
                List<Field> flds = new List<Field>();
                for (String fkey : r.fields.getMap().keyset()) {
                    Schema.DescribeFieldResult dfr = r.fields.getMap().get(fkey).getDescribe();
                    String ft = dfr.getType() + '';
                    if (ft == 'REFERENCE') {
                        ft += ' (' + dfr.getReferenceTo()[0] + ')';
                    }
                    flds.add(new Field(dfr.getName(), ft));
                }
                if (myTablesMap.containsKey(objName)) {
	                meta.add(new TableDescribe(objName, flds, myAppTables));
                } else {
	                allTables.add(new TableDescribe(objName, flds, myAppTables));
                }
            }
    	}
        fields = meta[0].fields;
        activeTable = meta[0];
        System.debug('Results :' + results);
    }
}