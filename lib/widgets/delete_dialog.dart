import 'package:flutter/material.dart';

deleteDialog(
    BuildContext context, String msg, Function callBack, Function popRestart) {
  final ctx = Theme.of(context);
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ctx.primaryColor,
          child: Container(
              padding: const EdgeInsets.all(10),
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(msg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(context),
                          icon: const Icon(Icons.cancel),
                          label: const Text("Cancel")),
                      TextButton.icon(
                          onPressed: () {
                            callBack();
                            Navigator.of(context).pop(context);
                            popRestart(context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          label: const Text('Delete',
                              style: TextStyle(color: Colors.red))),
                    ],
                  )
                ],
              )),
        );
      });
}
