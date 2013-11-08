public class ModelTemplateGenerator{

    String baseModel;
    
    public ModelTemplateGenerator() {
     	Document templ = [Select Id, Body From Document Where DeveloperName = 'Object_Model_Template'];
        baseModel = templ.Body.toString();
    }
    
    public String generateObjectModel(String objectName, List<String> fields) {
    	String result = baseModel.replaceAll('<objectnameUC>', objectName.capitalize());
        result = result.replaceAll('<objectnameLC>', objectName.uncapitalize());
        String fieldsString = '';
        for (String field : fields) {
            fieldsString += field + ', ';
        }
        fieldsString = fieldsString.substring(0, fieldsString.length() - 2);
        result = result.replace('<fieldList>', fieldsString);
        System.debug('Result: \n' + result);
        return result;
    }
}