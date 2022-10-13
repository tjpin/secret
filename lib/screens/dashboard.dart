import 'package:password_manager/imports.dart';
import 'package:password_manager/screens/profile_screen.dart';
import 'package:password_manager/screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  bool isDarkMode;
  Function changeTheme;
  Function setUser;
  TextEditingController userController;
  Dashboard(
      {Key? key,
      required this.isDarkMode,
      required this.changeTheme,
      required this.userController,
      required this.setUser})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final TextEditingController _userController = TextEditingController();

  int _selectedTab = 0;
  String file = '';
  String title = 'Dashboard';
  String user = '';

  List<Account> importedAccounts = [];
  List<String> titles = ['Dashboard', 'Accounts', 'Cards', 'About'];

  static const List<Widget> tabWidgets = [
    HomeScreen(),
    AccountsScreen(),
    CardsScreen(),
    AboutScreen(),
  ];

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
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _siteController.dispose();
    _passwordController.dispose();
    // _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: Text(title),
        actions: [
          _selectedTab != 1
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                    // showDialog(
                    //     context: context,
                    //     builder: (context) => Dialog(
                    //           child: UserDialog(
                    //               user: user,
                    //               ctx: ctx,
                    //               setUser: widget.setUser,
                    //               controller: widget.userController),
                    //         ));
                  },
                  icon: const Icon(Icons.account_circle),
                  splashRadius: 25)
              : IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(SearchScreen.routeName)
                  // showSearch(context: context, delegate: AccountSearchDelegate())
                  ,
                  icon: const Icon(
                    Icons.search,
                  ),
                  splashRadius: 25,
                ),
          _selectedTab != 1
              ? IconButton(
                  onPressed: () => widget.changeTheme(),
                  icon: Icon(
                      !widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  splashRadius: 25,
                )
              : PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  initialValue: 0,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        onTap: () => setState(() => _selectedTab = 3),
                        child: Row(
                          children: const [
                            Icon(Icons.question_mark_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text("How to import Accounts"),
                          ],
                        )),
                    PopupMenuItem(
                        onTap: () {
                          clearImportedAccounts(context);
                          FilePicker.platform.pickFiles(
                              allowedExtensions: ['csv'],
                              type: FileType.custom,
                              dialogTitle:
                                  'Select Password file.').then((value) {
                            setState(() {
                              file = value!.files.first.path!;
                            });
                            readImportedData(file, () => setState(() {}),
                                () => loaderOverlay(context), importedAccounts);
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.import_export),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Import browser Accounts"),
                          ],
                        )),
                    PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            accountsDeleteDialog(context, () {
                              deleteAllAccounts();
                              Navigator.of(context).pop(context);
                              setState(() {});
                            }, 'all accounts');
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.delete_forever_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Delete All Accounts"),
                          ],
                        )),
                    PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            accountsDeleteDialog(context, () {
                              deleteImportedAccounts();
                              Navigator.of(context).pop(context);
                              setState(() {});
                            }, 'imported accounts');
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.delete_outline),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Delete imported Accounts"),
                          ],
                        )),
                  ],
                  onSelected: (_) {},
                ),
        ],
      ),
      body: tabWidgets[_selectedTab],
      bottomNavigationBar: bottomNav(ctx),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedTab != 1
            ? null
            : () {
                showDialog(
                    context: context,
                    builder: (context) => AddAccountDialog(
                          refresh: () => setState(() {}),
                          nameController: _nameController,
                          usernameController: _usernameController,
                          siteController: _siteController,
                          passwordController: _passwordController,
                        ));
              },
        elevation: _selectedTab != 1 ? 0 : 2,
        backgroundColor:
            _selectedTab != 1 ? Colors.transparent : ctx.primaryColor,
        child: Icon(
          Icons.add,
          color: _selectedTab == 1 ? ctx.iconTheme.color : Colors.transparent,
          size: 28,
        ),
      ),
    );
  }

  BottomNavigationBar bottomNav(ThemeData ctx) {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      type: BottomNavigationBarType.fixed,
      backgroundColor: ctx.primaryColor,
      elevation: 0,
      selectedItemColor: ctx.colorScheme.secondary,
      selectedFontSize: 15,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      showUnselectedLabels: true,
      unselectedItemColor: ctx.colorScheme.secondary,
      onTap: (i) async {
        setState(() {
          _selectedTab = i;
          title = titles[_selectedTab];
        });
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.switch_account_outlined),
            activeIcon: Icon(Icons.switch_account),
            label: 'Accounts'),
        BottomNavigationBarItem(
            icon: Icon(Icons.payments_outlined),
            activeIcon: Icon(Icons.payment_rounded),
            label: 'Cards'),
        BottomNavigationBarItem(
            icon: Icon(Icons.more_vert_outlined),
            activeIcon: Icon(Icons.more_horiz_outlined),
            label: 'More'),
      ],
    );
  }
}
