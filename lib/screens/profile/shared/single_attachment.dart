import 'package:flutter/material.dart';
import '../../../model/profile/attachment.dart';
import '../../../theme-data.dart/box_shadow.dart';
import '../../../theme-data.dart/colors.dart';

class SingleAttachment extends StatelessWidget {
  final Function()? onpressed;
  final Attachment attachment;
  final Function()? view;
  const SingleAttachment({
    required this.attachment,
    required this.onpressed,
    required this.view,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.all(
                5),
        decoration: box1().copyWith(
            color: Colors
                .grey
                .shade300,
            boxShadow: []),
        child:
            Row(
          children: [
            Expanded(
              child:
                  GestureDetector(
                    onTap: view,
                    child: Text(
                             attachment.filename!,
                 
                                   maxLines: 1,
                                ),
                  ),
            ),
            const SizedBox(
              width:
                  8,
            ),
            GestureDetector(
                onTap:onpressed,
                child: const Icon(Icons.delete,color: primary,))
          ],
        ));
  }
}