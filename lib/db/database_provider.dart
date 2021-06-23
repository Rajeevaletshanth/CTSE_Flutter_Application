import 'package:CWCFlutter/model/job.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_JOB = "job";
  static const String COLUMN_ID = "id";
  static const String COLUMN_TITLE = "jobTitle";
  static const String COLUMN_DESC = "description";
  static const String COLUMN_SALARY = "salary";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'jobDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Adding Job Details");

        await database.execute(
          "CREATE TABLE $TABLE_JOB ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_TITLE TEXT,"
          "$COLUMN_DESC TEXT,"
          "$COLUMN_SALARY INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Job>> getJobs() async {
    final db = await database;

    var jobs = await db.query(TABLE_JOB,
        columns: [COLUMN_ID, COLUMN_TITLE, COLUMN_DESC, COLUMN_SALARY]);

    List<Job> jobList = List<Job>();

    jobs.forEach((currentJob) {
      Job job = Job.fromMap(currentJob);

      jobList.add(job);
    });

    return jobList;
  }

  Future<Job> insert(Job job) async {
    final db = await database;
    job.id = await db.insert(TABLE_JOB, job.toMap());
    return job;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_JOB,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Job job) async {
    final db = await database;

    return await db.update(
      TABLE_JOB,
      job.toMap(),
      where: "id = ?",
      whereArgs: [job.id],
    );
  }
}
