import 'package:final_project/Models/Schedule.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'Models/Production.dart';
import 'Models/Report.dart';
import 'Models/SingleTank.dart';
import 'Models/Status.dart';
import 'Models/Tanks.dart';
import 'Models/User.dart';
import '../Models/Data/Tanks_data.dart';
import 'objectbox.g.dart';

class ObjectBox extends TanksData {
  /// The Store of this app.
  late final Store store;
  late final Box<User> user;
  late final Box<Report> report;
  late final Box<Status> status;

  ObjectBox._create(this.store) {
    tanks = store.box<Tanks>();
    singleTank = store.box<SingleTank>();
    user = store.box<User>();
    production = store.box<Production>();
    schedule =store.box<Schedule>();
    status = store.box<Status>();
    report = store.box<Report>();

    _putDemoData();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));

    return ObjectBox._create(store);
  }

  void _putDemoData() {
    Tanks tank1 = Tanks(1, "drink", 222.2, 22);
    Tanks tank2 = Tanks(2, "plant", 222.2, 22);
    SingleTank stank1 = SingleTank(100, false);
    SingleTank stank2 = SingleTank(1020, true);
    SingleTank stank3 = SingleTank(2462, true);
    tank1.singleTank.addAll([stank1, stank2,stank3]);
    tank2.singleTank.addAll([stank1, stank2]);
    tanks.putMany([tank1, tank2]);
    Status status1 = Status("status 1");
    Status status2 = Status("status 2");
    Status status3 = Status("status 3");

    Report report1 = Report("Error in status 1!!");
    report1.status.target = status1;

    Report report2 = Report("Error in status 2!!");
    report2.status.target = status2;
    Report report3 = Report("Error in status 1!!");
    report3.status.target = status3;

    report.putMany([report1, report2, report3]);
  }

  void addReport(String note, Status statue) {
    Report newReport = Report(note);
    newReport.status.target = statue;
    report.put(newReport);
  }

  int addStatus(String name) {
    Status newStatue = Status(name);
    return status.put(newStatue);
  }

  Stream<List<Report>> getReports() {
    final builder = report.query()..order(Report_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }
}
