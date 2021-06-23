import 'package:CWCFlutter/db/database_provider.dart';

class Job {
  int id;
  String jobName;
  String description;
  String salary;

  Job({this.id, this.jobName, this.description, this.salary});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_TITLE: jobName,
      DatabaseProvider.COLUMN_DESC: description,
      DatabaseProvider.COLUMN_SALARY: salary
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Job.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    jobName = map[DatabaseProvider.COLUMN_TITLE];
    description = map[DatabaseProvider.COLUMN_DESC];
    salary = map[DatabaseProvider.COLUMN_SALARY];
  }
}
