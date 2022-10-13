import 'package:flutter/material.dart';
import '../data/db_access.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    Key? key,
    required Size size,
    required this.ctx,
    required this.user,
  })  : _size = size,
        super(key: key);
  final String user;
  final Size _size;
  final ThemeData ctx;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size.width,
      height: 200,
      decoration: BoxDecoration(
          color: ctx.primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: ctx.colorScheme.secondary.withOpacity(0.4))
          ],
          gradient: LinearGradient(
              colors: [ctx.primaryColor.withOpacity(0.85), Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: InkWell(
        onTap: () {},
        splashColor: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: Text(
                'Card',
                style: ctx.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
                bottom: 35,
                left: 10,
                child: Text(
                  '00/00',
                  style: ctx.textTheme.bodySmall,
                )),
            Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  '',
                  style: ctx.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Positioned(
                top: 60,
                left: 0,
                child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Image.asset(
                      'assets/images/chip.png',
                      fit: BoxFit.contain,
                    ))),
            Positioned(
                top: 60,
                left: 100,
                child: Chip(
                  label:
                      Text('${DbAccess.getCards().values.length} Cards saved'),
                  backgroundColor: ctx.primaryColor,
                )),
            Positioned(
                top: 110,
                left: 30,
                child: Text('Keep your cards organized in one place',
                    style: ctx.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ))),
            Positioned(
                top: 10,
                right: 5,
                child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Image.asset(
                      'assets/images/visa.png',
                      fit: BoxFit.contain,
                    ))),
            Positioned(
                right: 5,
                bottom: 10,
                child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Image.asset(
                      'assets/images/mastercard.png',
                      fit: BoxFit.contain,
                    ))),
            Positioned(
                right: 34,
                bottom: 5,
                child: Text(
                  'Mastercard',
                  style: ctx.textTheme.bodySmall!
                      .copyWith(color: ctx.primaryColor, fontSize: 10),
                )),
            Positioned(
                left: 10,
                bottom: 10,
                child: Text(
                  user,
                  style: ctx.textTheme.bodySmall!.copyWith(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
