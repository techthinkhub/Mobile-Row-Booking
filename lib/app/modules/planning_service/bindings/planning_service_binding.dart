import 'package:get/get.dart';

import '../controllers/planning_service_controller.dart';

class PlanningServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanningServiceController>(
      () => PlanningServiceController(),
    );
  }
}
