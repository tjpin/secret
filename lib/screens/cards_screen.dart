import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/data/db_access.dart';
import 'package:password_manager/imports.dart';
import 'package:password_manager/widgets/edit_card_dialog.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<CardData> cards = [];

  String getCardIcon(String text) {
    switch (text) {
      case 'Debit':
        return "assets/images/debit-blue.png";
      case 'Visa':
        return "assets/images/visa.png";
      case 'Mastercard':
        return "assets/images/mastercard_credit_card.png";
      case 'Discover':
        return "assets/images/discover.png";
      case 'Paytime':
        return "assets/images/paytime.png";
      case 'Default':
        return "assets/images/default-card.png";
      default:
        "assets/images/default-card.png";
        break;
    }
    return text;
  }

  @override
  void dispose() {
    DbAccess.getCards().compact();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
            child: ValueListenableBuilder<Box<CardData>>(
          valueListenable: DbAccess.getCards().listenable(),
          builder: (context, box, child) {
            cards = box.values.toList();
            return cards.isEmpty
                ? Center(
                    child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => const NewCardDialog());
                        },
                        icon: const Icon(Icons.add_card),
                        label: const Text("Add New Card")))
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, i) => GestureDetector(
                              onTap: () => Fluttertoast.showToast(
                                  msg: 'Long press for details'),
                              onLongPress: () => showModalBottomSheet(
                                  context: context,
                                  constraints:
                                      const BoxConstraints(maxHeight: 300),
                                  builder: (context) => Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 100,
                                                height: 60,
                                                child: Image.asset(
                                                  getCardIcon(
                                                      cards[i].cardType),
                                                  fit: BoxFit.cover,
                                                )),
                                            bottomCardItem(cards[i].name!,
                                                'Card Name:', ctx),
                                            bottomCardItem(
                                                cards[i].cardNumber.toString(),
                                                'Card Number:',
                                                ctx),
                                            bottomCardItem(cards[i].expiryDate!,
                                                'Expiry Date:', ctx),
                                            bottomCardItem(
                                                cards[i].cardCvv.toString(),
                                                'Cvv:',
                                                ctx),
                                          ],
                                        ),
                                      )),
                              child: CardTile(
                                  deleteCard: () {
                                    DbAccess.getCards().deleteAt(i);
                                    Fluttertoast.showToast(
                                        msg: "${cards[i].name!} Deleted",
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white);
                                    setState(() {});
                                  },
                                  updateCard: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => EditCardDialog(
                                            index: i, card: cards[i]));
                                    setState(() {});
                                  },
                                  cardName: cards[i].name!,
                                  image: getCardIcon(cards[i].cardType)),
                            )),
                  );
          },
        )),
        FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const NewCardDialog());
          },
          backgroundColor: ctx.primaryColor,
          child: const Icon(Icons.add_card),
        ),
        const SizedBox(
          height: 10,
          width: 1,
        )
      ],
    );
  }

  Row bottomCardItem(String info, String label, ThemeData ctx) {
    return Row(
      children: [
        Text(label, style: ctx.textTheme.bodySmall),
        const Spacer(),
        InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: info));
              Fluttertoast.showToast(msg: '$label Copied to clipboard');
            },
            child: Chip(
                label: Text(
              info,
              style: ctx.textTheme.bodyMedium,
            )))
      ],
    );
  }
}
