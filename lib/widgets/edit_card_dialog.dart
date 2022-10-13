import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/data/db_access.dart';
import 'package:password_manager/imports.dart';

class EditCardDialog extends StatefulWidget {
  int index;
  CardData card;
  EditCardDialog({Key? key, required this.index, required this.card})
      : super(key: key);

  @override
  State<EditCardDialog> createState() => _EditCardDialogState();
}

class _EditCardDialogState extends State<EditCardDialog> {
  String cardValue = 'Default';
  String expiryDate = '00/ 00';

  final cardNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardCvvController = TextEditingController();

  @override
  void dispose() {
    cardNameController.dispose();
    cardNumberController.dispose();
    cardCvvController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    if (cardNameController.text.isEmpty ||
        cardNumberController.text.isEmpty ||
        cardNumberController.text.length < 16 ||
        cardCvvController.text.isEmpty) return false;
    return true;
  }

  void setDefaultValues(CardData data) {
    setState(() {
      cardNameController.text = data.name.toString();
      cardNumberController.text = data.cardNumber.toString();
      cardCvvController.text = data.cardCvv.toString();
      cardValue = data.cardType;
    });
  }

  @override
  void initState() {
    setDefaultValues(widget.card);
    super.initState();
  }

  final items = [
    "Visa",
    "Debit",
    "Default",
    'Paytime',
    "Discover",
    "Mastercard",
  ];

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 450,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Chip(label: Text("Update Card")),
            DropdownButton(
                hint: const Text('Card Type'),
                value: cardValue,
                icon: const Icon(Icons.add_card),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                      cardValue = value.toString();
                    })),
            InputField(
              controller: cardNameController,
              ctx: ctx,
              hint: 'Card Name',
              minLength: 4,
              maxLength: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              controller: cardNumberController,
              ctx: ctx,
              hint: 'Card Number',
              maxLength: 16,
              minLength: 16,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              controller: cardCvvController,
              ctx: ctx,
              hint: 'CVV',
              formaters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              maxLength: 3,
              minLength: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(expiryDate),
              TextButton.icon(
                  onPressed: () async {
                    final selectedate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2022),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                        currentDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: ctx.primaryColor,
                                onPrimary: ctx.iconTheme.color!,
                                onSurface: ctx.iconTheme.color!,
                              ),
                            ),
                            child: child!,
                          );
                        });
                    setState(() {
                      if (selectedate == null) {
                        DateTime date = DateTime.now();
                        expiryDate =
                            "${date.month.toString()} / ${date.year.toString().substring(2)}";
                      } else {
                        DateTime _date = selectedate;
                        expiryDate = expiryDate =
                            "${_date.month.toString()} / ${_date.year.toString().substring(2)}";
                      }
                    });
                  },
                  icon: const Icon(Icons.access_time_filled),
                  label: const Text('Select Date'))
            ]),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(context),
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                ),
                TextButton.icon(
                    onPressed: () {
                      CardData card = CardData()
                        ..name = cardNameController.text
                        ..cardNumber = int.parse(cardNumberController.text)
                        ..cardCvv = int.parse(cardCvvController.text)
                        ..cardType = cardValue
                        ..expiryDate = expiryDate;
                      DbAccess.getCards().putAt(widget.index, card);
                      Navigator.of(context).pop(context);
                      Fluttertoast.showToast(
                          msg:
                              '${cardNameController.text} updated successifuly',
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                    },
                    icon: const Icon(Icons.add_card_rounded),
                    label: const Text("Update Card")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
