import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CostumToggleSwitch extends StatelessWidget {
  final List<Color> activeBGColors;
  final List<IconData> icons;
final int initialLabelIndex;
  final void Function(int?)? onToggle;
  final List<String> labels;
  const CostumToggleSwitch(
      {Key? key,
      required this.activeBGColors,
      required this.icons,
      required this.onToggle,
      required this.labels,
      required this.initialLabelIndex
    
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 80,
      child: ToggleSwitch(
          minWidth: 150.0,
          cornerRadius: 25.0,
          activeBgColors: [
            [Colors.green[800]!],
            [Colors.red[800]!]
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          initialLabelIndex: initialLabelIndex,
          totalSwitches: 2,
          labels: labels,
          icons: icons,
          radiusStyle: false,
          onToggle: onToggle),
    );
  }
}
