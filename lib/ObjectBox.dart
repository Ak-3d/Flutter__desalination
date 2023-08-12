import 'package:final_project/Components/Tank.dart';
import 'package:final_project/Models/Irrgation.dart';
import 'package:final_project/Models/Schedule.dart';
import 'package:final_project/Models/WaterFlow.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'Models/Production.dart';
import 'Models/Report.dart';
import 'Models/SingleTank.dart';
import 'Models/Status.dart';
import 'Models/Tanks.dart';
import 'Models/User.dart';
import 'objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;
  late final Box<User> user;
  late final Box<Report> report;
  late final Box<Status> status;
  late final Box<WaterFlow> waterFlow;
  late final Box<Irrigation> irregation;
  late final Box<Tanks> tanks;
  late final Box<SingleTank> singleTank;
  late final Box<Production> production;
  late final Box<Schedule> schedule;

  ObjectBox._create(this.store) {
    tanks = store.box<Tanks>();
    singleTank = store.box<SingleTank>();
    user = store.box<User>();
    production = store.box<Production>();
    schedule = store.box<Schedule>();
    irregation = store.box<Irrigation>();
    status = store.box<Status>();
    report = store.box<Report>();
    waterFlow = store.box<WaterFlow>();

    if(status.isEmpty()) {
      _putDefault();
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));

    return ObjectBox._create(store);
  }

  void _putDefault() {
    status.put(Status('Pending'));
    status.put(Status('Running'));
    status.put(Status('Done'));

    tanks.put(Tanks(0, 'Drink', 120, 0));
    tanks.put(Tanks(1, 'Demo Plant', 500, 2000));
  }
}
