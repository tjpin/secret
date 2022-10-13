import 'package:password_manager/imports.dart';
import 'package:url_launcher/url_launcher.dart';

import '../infor/information.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ctx = Theme.of(context);
    final mode =
        Theme.of(context).appBarTheme.systemOverlayStyle!.statusBarBrightness;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView(
        children: [
          const Center(
            child: Chip(label: Text('User Notice')),
          ),
          Text("How to import from Desktop or Laptop",
              style: ctx.textTheme.bodyMedium!
                  .copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text(howToImportAccounts,
              style: ctx.textTheme.bodySmall!.copyWith(fontSize: 16)),
          Text("How to import from mobile",
              style: ctx.textTheme.bodyMedium!
                  .copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text(importForMobile,
              style: ctx.textTheme.bodySmall!.copyWith(fontSize: 16)),
          Text("Security Notice",
              style: ctx.textTheme.bodyMedium!
                  .copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text(secutityWarning,
              style: ctx.textTheme.bodySmall!.copyWith(fontSize: 16)),
          Column(
            children: [
              Center(
                child: TextButton(
                    child: Text("About Developer",
                        style: ctx.textTheme.bodySmall!.copyWith(
                          color: mode == Brightness.dark
                              ? Colors.blue
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () {
                      launchUrl(Uri.parse('https://github.com/tjpin'));
                    }),
              ),
              const Text(
                  'App version: 1.0 - Latest'), // to be updated dymamicaly in future
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }
}
