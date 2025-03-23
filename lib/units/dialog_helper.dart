import 'package:application_map_todolist/widgets/Tutorial.dart';
import 'package:flutter/material.dart';

class DialogHelper {

  static void showHowToUseAppDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            height: 550,
            child: Tutorial()
          ),
        );
      },
    );
  }

  static Future<bool?> confirmDelete({required BuildContext context, required String text}) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Image.asset(
              height: 200,
              width: 200,
              'assets/image_sticker/sticker_think_confirmdelete.png'
            ),
          ),
          content: Text(text, style: TextStyle(fontSize: 16),),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CloseButton(
                  color: const Color.fromARGB(255, 98, 197, 162),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }
                ),
                IconButton(
                  icon: Icon(Icons.done, color: const Color.fromARGB(255, 98, 197, 162)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
}
