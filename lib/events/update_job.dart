import 'package:CWCFlutter/model/job.dart';

import 'job_event.dart';

class UpdateJob extends JobEvent {
  Job newJob;
  int jobIndex;

  UpdateJob(int index, Job job) {
    newJob = job;
    jobIndex = index;
  }
}
