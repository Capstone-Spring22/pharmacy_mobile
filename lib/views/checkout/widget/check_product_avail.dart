import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/views/checkout/widget/pick_date.dart';
import 'package:pharmacy_mobile/views/checkout/widget/pick_store.dart';
import 'package:pharmacy_mobile/views/checkout/widget/pick_time.dart';

class CheckProductAvailbility extends StatefulWidget {
  const CheckProductAvailbility({super.key});

  @override
  State<CheckProductAvailbility> createState() =>
      _CheckProductAvailbilityState();
}

class _CheckProductAvailbilityState extends State<CheckProductAvailbility> {
  late int activeStep;
  CheckoutController checkoutController = Get.find();
  @override
  void initState() {
    super.initState();
    activeStep = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        checkoutController.scrollController.value?.animateTo(
          checkoutController.scrollController.value!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

  List<Widget> widgetList = [
    const PickStore(),
    const PickDate(),
    const PickTime(),
  ];

  final GlobalKey<_SwitchFadeWidgetState> childKey =
      GlobalKey<_SwitchFadeWidgetState>();

  void onPageChanged(int pageIndex) {
    // Do something with the page index
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: EasyStepper(
              activeStep: activeStep,
              lineLength: 70,
              stepShape: StepShape.rRectangle,
              stepBorderRadius: 15,
              borderThickness: 2,
              stepRadius: 28,
              direction: Axis.vertical,
              finishedStepBorderColor: context.theme.primaryColor,
              finishedStepTextColor: context.theme.primaryColor,
              finishedStepBackgroundColor: context.theme.primaryColor,
              activeStepIconColor: context.theme.primaryColor,
              loadingAnimation: 'assets/lottie/loading.json',
              steps: const [
                EasyStep(
                  icon: Icon(Icons.store),
                  title: 'Chọn cửa hàng',
                ),
                EasyStep(
                  icon: Icon(Icons.date_range),
                  title: 'Chọn ngày',
                ),
                EasyStep(
                  icon: Icon(Icons.access_time_filled_rounded),
                  title: 'Chọn giờ',
                ),
              ],
              onStepReached: (index) {
                setState(() => activeStep = index);
                childKey.currentState?.pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SwitchFadeWidget(
                  list: widgetList,
                  key: childKey,
                  onPageChanged: (index) {
                    setState(() => activeStep = index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchFadeWidget extends StatefulWidget {
  const SwitchFadeWidget(
      {super.key, required this.list, required this.onPageChanged});

  final List<Widget> list;
  final Function(int) onPageChanged;

  @override
  State<SwitchFadeWidget> createState() => _SwitchFadeWidgetState();
}

class _SwitchFadeWidgetState extends State<SwitchFadeWidget> {
  PageController pageController = PageController();

  PageController get controller => pageController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.height * .5,
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple,
                Colors.transparent,
                Colors.transparent,
                Colors.purple
              ],
              stops: [0.0, 0.1, 0.9, 1.0],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: PageView(
            controller: controller,
            onPageChanged: widget.onPageChanged,
            scrollDirection: Axis.vertical,
            children: widget.list,
          ),
        ),
      ),
    );
  }
}
