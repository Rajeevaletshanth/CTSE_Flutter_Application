import 'package:CWCFlutter/events/add_job.dart';
import 'package:CWCFlutter/events/delete_job.dart';
import 'package:CWCFlutter/events/job_event.dart';
import 'package:CWCFlutter/events/set_jobs.dart';
import 'package:CWCFlutter/events/update_job.dart';
import 'package:CWCFlutter/model/job.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobBloc extends Bloc<JobEvent, List<Job>> {
  @override
  List<Job> get initialState => List<Job>();

  @override
  Stream<List<Job>> mapEventToState(JobEvent event) async* {
    if (event is SetJobs) {
      yield event.jobList;
    } else if (event is AddJob) {
      List<Job> newState = List.from(state);
      if (event.newJob != null) {
        newState.add(event.newJob);
      }
      yield newState;
    } else if (event is DeleteJob) {
      List<Job> newState = List.from(state);
      newState.removeAt(event.jobIndex);
      yield newState;
    } else if (event is UpdateJob) {
      List<Job> newState = List.from(state);
      newState[event.jobIndex] = event.newJob;
      yield newState;
    }
  }
}
