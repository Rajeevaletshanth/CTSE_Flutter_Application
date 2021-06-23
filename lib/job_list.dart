import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/delete_job.dart';
import 'package:CWCFlutter/events/set_jobs.dart';
import 'package:CWCFlutter/job_form.dart';
import 'package:CWCFlutter/model/job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/job_bloc.dart';

class JobList extends StatefulWidget {
  const JobList({Key key}) : super(key: key);

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getJobs().then(
      (jobList) {
        BlocProvider.of<JobBloc>(context).add(SetJobs(jobList));
      },
    );
  }

  showJobDialog(BuildContext context, Job job, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job.jobName),
        content: Text("ID ${job.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => JobForm(job: job, jobIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(job.id).then((_) {
              BlocProvider.of<JobBloc>(context).add(
                DeleteJob(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire job list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text("Job List"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: BlocConsumer<JobBloc, List<Job>>(
          builder: (context, jobList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("jobList: $jobList");

                Job job = jobList[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(job.jobName, style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "Description: ${job.description}\nSalary: ${job.salary}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showJobDialog(context, job, index),
                  ),
                );
              },
              itemCount: jobList.length,
            );
          },
          listener: (BuildContext context, jobList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => JobForm()),
        ),
      ),
    );
  }
}
