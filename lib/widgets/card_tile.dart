import 'package:password_manager/imports.dart';

class CardTile extends StatefulWidget {
  String image;
  String cardName;
  Function? deleteCard;
  Function? updateCard;
  CardTile(
      {Key? key,
      required this.image,
      required this.cardName,
      this.deleteCard,
      this.updateCard})
      : super(key: key);

  @override
  State<CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.edit,
              color: ctx.iconTheme.color,
            ),
            const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ],
        ),
      ),
      onDismissed: (d) {
        if (d == DismissDirection.endToStart) {
          accountsDeleteDialog(context, () {
            widget.deleteCard!();
            Navigator.of(context).pop();
          }, 'card');
        }
        if (d == DismissDirection.startToEnd) {
          widget.updateCard!();
        }
      },
      child: Card(
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ctx.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Image.asset(
                  widget.image.isEmpty
                      ? 'assets/images/default-card.png'
                      : widget.image,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                widget.cardName,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
