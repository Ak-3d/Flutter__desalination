import 'package:final_project/Models/Data/Production_data.dart';

import '../../objectbox.g.dart';
import '../Days.dart';

import '../Schedule.dart';

class ScheduleData extends ProductionData {
  late Box<Schedule> schedule;
  late Box<Days> days;

  Stream<List<Schedule>> getAllSchedule() {
    final builder = schedule.query()
      ..order(Schedule_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  Schedule? getScheduleById(int productionId) {
    final builder = schedule.get(productionId);

    return builder;
  }

  Schedule addNewSchedule(DateTime time, DateTime modifiedDate) {
    Schedule newSchedule = Schedule(time, modifiedDate);
    return newSchedule;
  }

  Days addNewDays(int selectDays) {
    Days newDays = Days(selectDays);
    return newDays;
  }

  void linkScheduleWithDays(Schedule selectSchedule, Days selectDays) {
    selectSchedule.days.add(selectDays);
    schedule.put(selectSchedule);
    days.put(selectDays);
  }

  void updateSchedule(int id, DateTime time) {
    final update = schedule.get(id);
    update?.time = time;
    update?.modifiedDate = DateTime.now();

    schedule.put(update!);
  }

  void updateDays(int id, int day) {
    final update = days.get(id);
    update?.day = day;

    days.put(update!);
  }
}
