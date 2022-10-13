import 'package:password_manager/imports.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  int _currentPage = 0;
  bool searcEnabled = true;
  late PageController? _pageController;

  void switchPage(int i) async {
    setState(() {
      _pageController!.animateToPage(i,
          duration: const Duration(microseconds: 200), curve: Curves.easeInOut);
      _currentPage = i;
    });
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    List<Widget> accountPages = const [
      AddedAccountsPage(),
      ImportedAccountsPage(),
      FavoriteAccountsScreen(),
    ];

    return Column(
      children: [
        Container(
            width: double.infinity,
            height: 60,
            alignment: Alignment.topCenter,
            color: ctx.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                accountTabButton(ctx, Icons.switch_account_rounded, 'Accounts',
                    () => switchPage(0), _currentPage, 0),
                accountTabButton(ctx, Icons.import_export_sharp,
                    'Imported Accounts', () => switchPage(1), _currentPage, 1),
                accountTabButton(ctx, Icons.favorite, 'Favorite',
                    () => switchPage(2), _currentPage, 2),
              ],
            )),
        Expanded(
            child: PageView(
          controller: _pageController,
          children: accountPages,
          onPageChanged: (pageIndex) {
            setState(() {
              _currentPage = pageIndex;
            });
          },
        ))
      ],
    );
  }

  TextButton accountTabButton(ThemeData ctx, IconData icon, String label,
      Function switchPage, int pageIndex, int index) {
    return TextButton.icon(
        onPressed: () => switchPage(),
        icon: Icon(
          icon,
          color: pageIndex == index ? ctx.dividerColor : ctx.iconTheme.color,
        ),
        label: Text(
          label,
          style: ctx.textTheme.bodySmall!.copyWith(
            color: pageIndex == index ? ctx.dividerColor : ctx.iconTheme.color,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
