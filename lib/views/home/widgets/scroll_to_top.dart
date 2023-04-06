import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class ScrollToTop extends StatelessWidget {
  const ScrollToTop({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ScrollWrapper(
      promptAlignment: const Alignment(1, -0.8),
      promptReplacementBuilder: (context, function) {
        return NeumorphicButton(
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            color: Colors.white,
            shape: NeumorphicShape.flat,
          ),
          onPressed: () => function(),
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.black,
          ),
        );
      },
      builder: (context, properties) {
        return child;
      },
    );
  }
}
