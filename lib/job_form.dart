import 'package:CWCFlutter/bloc/job_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/add_job.dart';
import 'package:CWCFlutter/events/update_job.dart';
import 'package:CWCFlutter/model/job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobForm extends StatefulWidget {
  final Job job;
  final int jobIndex;

  JobForm({this.job, this.jobIndex});

  @override
  State<StatefulWidget> createState() {
    return JobFormState();
  }
}

class JobFormState extends State<JobForm> {
  String _jobName;
  String _description;
  String _salary;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitle() {
    return TextFormField(
      initialValue: _jobName,
      decoration: InputDecoration(labelText: 'Job Title'),
      maxLength: 35,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Job title is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _jobName = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      initialValue: _jobName,
      decoration: InputDecoration(labelText: 'Description'),
      maxLength: 100,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Job description is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _description = value;
      },
    );
  }

  Widget _buildSalary() {
    return TextFormField(
      initialValue: _description,
      decoration: InputDecoration(labelText: 'Salary'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int salary = int.tryParse(value);

        if (salary == null || salary <= 5000) {
          return 'Salary must be greater than 5000';
        }

        return null;
      },
      onSaved: (value) {
        _salary = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _jobName = widget.job.jobName;
      _description = widget.job.description;
      _salary = widget.job.salary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Form")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitle(),
              _buildDescription(),
              _buildSalary(),
              SizedBox(height: 20),
              widget.job == null
                  ? RaisedButton(
                      child: Text(
                        'Add Job',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        Job job = Job(
                          jobName: _jobName,
                          description: _description,
                          salary: _salary,
                        );

                        DatabaseProvider.db.insert(job).then(
                              (storedJob) =>
                                  BlocProvider.of<JobBloc>(context).add(
                                AddJob(storedJob),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState.save();

                            Job job = Job(
                              jobName: _jobName,
                              description: _description,
                              salary: _salary,
                            );

                            DatabaseProvider.db.update(widget.job).then(
                                  (storedJob) =>
                                      BlocProvider.of<JobBloc>(context).add(
                                    UpdateJob(widget.jobIndex, job),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
