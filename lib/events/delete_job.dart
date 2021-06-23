import 'job_event.dart';

class DeleteJob extends JobEvent {
  int jobIndex;

  DeleteJob(int index) {
    jobIndex = index;
  }
}
