import 'package:password_manager/imports.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String user = '';

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('user') ?? "setup username";
    setState(() {
      user = savedUser;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
                color: ctx.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: const Text("Saved Cards"),
                        backgroundColor: ctx.primaryColor.withOpacity(0.1),
                      ),
                      PaymentCard(size: size, ctx: ctx, user: user),
                      const spacerBox()
                    ],
                  ),
                )),
            const spacerBox(),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      label: const Text("Account Analysis"),
                      backgroundColor: ctx.primaryColor.withOpacity(0.1),
                    ),
                    accountInfo(
                      ctx: ctx,
                      title: 'Added Accounts',
                      info: '${getAddedAccountsCount()}',
                    ),
                    const spacerBox(),
                    accountInfo(
                      ctx: ctx,
                      title: 'Imported Accounts',
                      info: '${getImportedAccountsCount()}',
                    ),
                    const spacerBox(),
                    accountInfo(
                        ctx: ctx,
                        title: 'Favorite Accounts',
                        info: '${getFavAccountsCount()}'),
                    const spacerBox(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: CircularPercentIndicator(
                radius: 70,
                percent: 1,
                lineWidth: 10,
                progressColor: Colors.blue.shade400,
                center: FittedBox(
                    child: Text(
                        '${getAddedAccountsCount() + getImportedAccountsCount()} Accounts')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class accountInfo extends StatelessWidget {
  ThemeData ctx;
  String title;
  String info;
  accountInfo({
    Key? key,
    required this.ctx,
    required this.title,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: ctx.textTheme.bodySmall!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 16.5),
        ),
        const Spacer(),
        Text(
          info,
          style: ctx.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class spacerBox extends StatelessWidget {
  const spacerBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}
