import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/profile/learning_development.dart';

class TrainingDisplayDetails extends StatelessWidget {
  final ConductedTraining e;
  final Function() notWhatYourLookingFor;
  const TrainingDisplayDetails({super.key, required this.e, required this.notWhatYourLookingFor});

  @override
  Widget build(BuildContext context) {
    DateFormat dteFormat2 = DateFormat.yMMMMd('en_US');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.title!.title!.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "CONDUCTED BY:",
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 8),
            ),
            Text(e.conductedBy!.name!, style: const TextStyle(fontSize: 12)),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Flexible(
                    child: Text(
                  dteFormat2.format(e.fromDate!),
                  style: Theme.of(context).textTheme.labelSmall,
                )),
                const Text(" - "),
                Flexible(
                    child: Text(
                  dteFormat2.format(e.toDate!),
                  style: Theme.of(context).textTheme.labelSmall,
                ))
              ],
            ),
            Text("Total (hours): ${e.totalHours}",
                style: Theme.of(context).textTheme.labelSmall),
            Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: notWhatYourLookingFor,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "NOT WHAT LOOKING FOR?",
                      style: TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
