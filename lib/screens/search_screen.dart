import 'package:password_manager/imports.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "search";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Account> allAccounts = [];
  int seachIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    allAccounts = DbAccess.getAccount().values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      splashRadius: 25,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _controller,
                        cursorColor: ctx.iconTheme.color,
                        textAlign: TextAlign.center,
                        autocorrect: true,
                        autofocus: true,
                        onChanged: (value) {
                          List<Account> newList = DbAccess.getAccount()
                              .values
                              .where((element) => element.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                          setState(() {
                            allAccounts = newList;
                          });
                        },
                        decoration: const InputDecoration(
                            hintText: 'Search account...',
                            suffixIcon: Icon(Icons.search)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    _controller.text.isEmpty
                        ? const Text('')
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                                allAccounts =
                                    DbAccess.getAccount().values.toList();
                              });
                            },
                            icon: const Icon(Icons.clear),
                            splashRadius: 25,
                          ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: allAccounts.length,
                  itemBuilder: (context, i) => ListTile(
                        title: Text(
                          allAccounts[i].name!,
                          style: ctx.textTheme.bodyMedium,
                        ),
                        subtitle: Text(allAccounts[i].username!,
                            style: ctx.textTheme.bodyMedium!.copyWith(
                                color: ctx.iconTheme.color!.withOpacity(0.7))),
                        selected: seachIndex == i ? true : false,
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: ctx.primaryColor,
                            child: Text(
                              allAccounts[i]
                                  .username!
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: ctx.textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              DbAccessHelper()
                                  .setFavoriteAccount(allAccounts[i]);
                            });
                          },
                          icon: allAccounts[i].isFavorite == false
                              ? const Icon(Icons.favorite_border_outlined,
                                  size: 15)
                              : const Icon(Icons.favorite, size: 15),
                          splashRadius: 25,
                        ),
                        onLongPress: () =>
                            showDetails(context, ctx, allAccounts[i]),
                        onTap: () {
                          setState(() {
                            seachIndex = i;
                          });
                        },
                      )))
        ],
      ),
    );
  }
}
