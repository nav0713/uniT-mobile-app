import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/global.dart';

class TrainingDetails extends StatelessWidget {
  final String trainingTitle;
  final double totalHours;
  final String trainingTopic;
  final String toDate;
  final String fromDate;
  final String conductedBy;
  
  const TrainingDetails({super.key, required this.trainingTitle, required this.totalHours, required this.trainingTopic, required this.toDate, required this.fromDate, required this.conductedBy});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: TextFormField(
                                                enabled: false,
                                                initialValue: trainingTitle,
                                                decoration:
                                                    normalTextFieldStyle("", "")
                                                        .copyWith(
                                                            labelText: "Type",
                                                            fillColor: Colors
                                                                .grey.shade200,
                                                            filled: true)),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Flexible(
                                              child: TextFormField(
                                                  enabled: false,
                                                  initialValue: totalHours
                                                      .toString(),
                                                  decoration: normalTextFieldStyle(
                                                          "", "")
                                                      .copyWith(
                                                          labelText:
                                                              "Total Hours Conducted",
                                                          fillColor: Colors
                                                              .grey.shade200,
                                                          filled: true))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                        enabled: false,
                                        maxLines: 3,
                                        initialValue:
                                      trainingTopic,
                                        decoration: normalTextFieldStyle("", "")
                                            .copyWith(
                                                labelText: "Topic",
                                                fillColor: Colors.grey.shade200,
                                                filled: true)),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      width: screenWidth,
                                      child: Row(
                                        children: [
                                          //// FROM DATE
                                          Flexible(
                                              flex: 1,
                                              child: DateTimePicker(
                                                enabled: false,
                                                firstDate: DateTime(1970),
                                                lastDate: DateTime(2100),
                                                initialValue:fromDate,
                                                use24HourFormat: false,
                                                icon: const Icon(
                                                    Icons.date_range),
                                                timeHintText:
                                                    "Date of Examination/Conferment",
                                                decoration:
                                                    normalTextFieldStyle(
                                                            "From", "From")
                                                        .copyWith(
                                                            fillColor: Colors
                                                                .grey.shade200,
                                                            filled: true,
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.date_range,
                                                              color: Colors
                                                                  .black87,
                                                            )),
                                              )),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          //// TO DATE
                                          Flexible(
                                            flex: 1,
                                            child: DateTimePicker(
                                              enabled: false,
                                              initialValue:toDate,
                                              firstDate: DateTime(1970),
                                              lastDate: DateTime(2100),
                                              decoration: normalTextFieldStyle(
                                                      "To", "To")
                                                  .copyWith(
                                                fillColor: Colors.grey.shade200,
                                                filled: true,
                                                prefixIcon: const Icon(
                                                  Icons.date_range,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                        enabled: false,
                                        maxLines: 3,
                                        initialValue:conductedBy,
                                        decoration: normalTextFieldStyle("", "")
                                            .copyWith(
                                                labelText: "Conducted By",
                                                fillColor: Colors.grey.shade200,
                                                filled: true)),
                                  ],
                                ),
                              );
  }
}