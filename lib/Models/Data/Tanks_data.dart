import 'package:final_project/Models/Production.dart';
import '../../objectbox.g.dart';
import '../Schedule.dart';
import '../Tanks.dart';
import '../SingleTank.dart';
import 'Schedule_data.dart';

class TanksData extends ScheduleData {
  late Box<SingleTank> singleTank;
  late Box<Tanks> tanks;

  Stream<List<Tanks>> getAllTanks() {
    final builder = tanks.query()..order(Tanks_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  Tanks? getTankById(int tankId) {
    final builder = tanks.get(tankId);
    return builder;
  }

  Stream<List<SingleTank>> getAllSingleTanks(int tankId) {
    final builder = singleTank.query()
      ..order(SingleTank_.id, flags: Order.descending);
    builder.link(SingleTank_.tanks, Tanks_.id.equals(tankId));
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Tanks addNewTank(int portNumber, String plantName, double tdsValue,
      double irrigationVolume) {
    Tanks newTank = Tanks(portNumber, plantName, tdsValue, irrigationVolume);

    return newTank;
  }

  int addSingleTank(double level, bool isFilling) {
    SingleTank newSingleTank = SingleTank(level, isFilling);

    return singleTank.put(newSingleTank);
  }

  void linkAll(Tanks selectTanks, SingleTank selectSingleTanks,
      Production selectProduction, Schedule selectSchedule) {
    selectTanks.singleTank.add(selectSingleTanks);
    selectTanks.production.add(selectProduction);
    selectTanks.schedule.add(selectSchedule);
    tanks.put(selectTanks);
    singleTank.put(selectSingleTanks);
    production.put(selectProduction);
    schedule.put(selectSchedule);
  }

  void removeTank(int tankId) {
    singleTank.removeAsync(tankId);
    tanks.remove(tankId);
  }

  void updateTank(int id, int portNumber, String plantName, double tdsValue,
      double irrigationVolume) {
    final update = tanks.get(id);
    update?.modifiedDate = DateTime.now();
    update?.irrigationVolume = irrigationVolume;
    update?.portNumber = portNumber;
    update?.tdsValue = tdsValue;
    update?.tdsValue = tdsValue;
    tanks.put(update!);
  }

  void updateSingleTank(int id, double level, bool isFilling) {
    final update = singleTank.get(id);
    update?.isFilling = isFilling;
    update?.level = level;

    singleTank.put(update!);
  }
}
