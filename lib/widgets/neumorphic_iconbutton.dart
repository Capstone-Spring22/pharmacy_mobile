import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({super.key, required this.icon, required this.fn});
  final Widget icon;
  final VoidCallback fn;
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.circle(),
        color: Colors.white,
      ),
      onPressed: fn,
      child: icon,
    );
  }
}
