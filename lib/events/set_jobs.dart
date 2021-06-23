import 'package:CWCFlutter/model/job.dart';

import 'job_event.dart';

class SetJobs extends JobEvent {
  List<Job> jobList;

  SetJobs(List<Job> jobs) {
    jobList = jobs;
  }
}
