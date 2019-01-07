import 'database_engine.dart';

class Project {
  DataBaseEngine dataBaseEngine = new DataBaseEngine();

  bool processProjectData(Map<String, String> data) {
    if (!validateFields(data)) {
      return false;
    }

    //Add Information to database
    dataBaseEngine.addData('activeProjects', data);
    return true;
  }

  bool validateFields(Map<String, String> data) {
    bool emptyFieldFound = false;

    data.forEach((key, value) {
      if (value.isEmpty) {
        emptyFieldFound = true;
      }
    });

    if (emptyFieldFound) {
      return false;
    } else {
      return true;
    }
  }
}
