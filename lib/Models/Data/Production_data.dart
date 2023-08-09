import '../../objectbox.g.dart';
import '../Production.dart';

class ProductionData {
  late Box<Production> production;

  Stream<List<Production>> getAllProduction() {
    final builder = production.query()
      ..order(Production_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  Production? getProductionById(int productionId) {
    final builder = production.get(productionId);

    return builder;
  }

  Production addNewProduction(
    double flowWaterPermeate,
    double flowWaterConcentrate,
    double tdsValue,
    double temperatureValue,
  ) {
    Production newProduction = Production(
        tdsValue, flowWaterConcentrate, flowWaterPermeate, temperatureValue);

    return newProduction;
  }

  void updateProduction(
    int id,
    double flowWaterPermeate,
    double flowWaterConcentrate,
    double tdsValue,
    double temperatureValue,
  ) {
    final update = production.get(id);
    update?.flowWaterPermeate = flowWaterPermeate;
    update?.flowWaterConcentrate = flowWaterConcentrate;
    update?.tdsValue = tdsValue;
    update?.temperatureValue = temperatureValue;

    production.put(update!);
  }
}