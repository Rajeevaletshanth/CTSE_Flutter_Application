import 'package:CWCFlutter/model/job.dart';

import 'job_event.dart';

class AddJob extends JobEvent {
  Job newJob;

  AddJob(Job job) {
    newJob = job;
  }
}
