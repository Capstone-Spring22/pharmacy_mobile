import 'package:easy_stepper/easy_stepper.dart';
import 'package:pharmacy_mobile/views/order_history/models/order_history.dart';

class OnlineOrderTile extends StatelessWidget {
  const OnlineOrderTile({super.key, required this.order});

  final OrderHistory order;

  @override
  Widget build(BuildContext context) {
    int activeStep = int.parse(order.orderStatus!);
    return EasyStepper(
      activeStep: activeStep,
      steps: const [
        EasyStep(
          icon: Icon(Icons.store),
          title: 'Pick Store',
        ),
        EasyStep(
          icon: Icon(Icons.date_range),
          title: 'Pick Date',
        ),
        EasyStep(
          icon: Icon(Icons.access_time_filled_rounded),
          title: 'Pick Time',
        ),
      ],
    );
  }
}
