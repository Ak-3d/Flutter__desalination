import 'package:final_project/Models/Days.dart';
import 'package:final_project/Models/Power.dart';
import 'package:final_project/Models/Irrigation.dart';
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
  late final Box<Power> power;
  late final Box<Days> days;

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
    power = store.box<Power>();
    days = store.box<Days>();

    // _flushData(); //TODO delete in production
    _putDefault();
    // _putDummy();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));

    return ObjectBox._create(store);
  }

  void _putDefault() {
    if (status.isEmpty()) {
      status.put(Status('Pending'));
      status.put(Status('Running'));
      status.put(Status('Done'));
    }

    if (tanks.isEmpty()) {
      tanks.put(Tanks(1, 'Drink', 120, 0));
      tanks.put(Tanks(2, 'Demo Plant', 500, 2000));
    }
  }

  void _flushData() {
    tanks
        .query(Tanks_.id.notEquals(1).and(Tanks_.id.notEquals(2)))
        .build()
        .remove();
    power.removeAll();
    singleTank.removeAll();
    production.removeAll();
    irregation.removeAll();
    schedule.removeAll();
    days.removeAll();
    irregation.removeAll();
  }

  void _putDummy() {
    DateTime nowTemp = DateTime.now();
    Tanks t1 = Tanks(1, 'Drink', 120, 0);
    Tanks t2 = Tanks(2, 'Demo Plant', 120, 2000);
    tanks.put(t1);
    tanks.put(t2);

    List<Days> d1 = [Days(6), Days(2)];

    Schedule sch1 = Schedule(10, 40, nowTemp);
    sch1.tanks.target = t1;
    sch1.days.addAll(d1);

    List<Days> d2 = [Days(3), Days(5)];
    Schedule sch2 = Schedule(17, 20, nowTemp);
    sch2.tanks.target = t2;
    sch2.days.addAll(d2);

    schedule.putMany([sch1, sch2]);

    for (var i = 0; i < 20; i++) {
      Power e = Power(10, 5, 2, 10, true, 1);
      power.put(e);

      SingleTank s = SingleTank(i * 100 / 20, false);
      s.tanks.targetId = i % 2 == 0 ? t1.id : t2.id;
      singleTank.put(s);

      Production p = Production(20, 20, 10, 27);
      production.put(p);

      Irrigation irr1 = Irrigation(i * 10, t1.plantName, t1.portNumber,
          t1.tdsValue, t2.id, nowTemp.subtract(Duration(days: i)));
      irr1.schedule.target = sch1;
      irr1.tankID = t1.id;

      Irrigation irr2 = Irrigation(i * 20, t2.plantName, t2.portNumber,
          t2.tdsValue, t2.id, nowTemp.subtract(Duration(days: i)));
      irr2.tankID = t2.id;

      irregation.putMany([irr1, irr2]);
    }
  }
}
