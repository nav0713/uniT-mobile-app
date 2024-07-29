import 'package:flutter/material.dart';

import '../../../../utils/global.dart';

class LoginViaQr extends StatelessWidget {
  final String text;
  const LoginViaQr({Key? key,@required required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: blockSizeVertical * 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const SizedBox(
              width: 30,
              child: Divider(
                color: Colors.grey,
                height: 2,
              ),
            ),
            // LOGIN VIA QR CODE
            Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              width: 30,
              child: Divider(
                color: Colors.grey,
                height: 2,
              ),
            ),
          ],
        ));
  }
}
