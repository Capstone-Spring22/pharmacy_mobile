import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/widgets/button.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAFCFF),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80.w,
                      child: Icon(
                        Icons.account_circle,
                        size: 100.w,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Hero(
                              tag: 'signupBtn',
                              child: PharmacyButton(
                                onPressed: () => Get.toNamed("/signup"),
                                text: "Sign up",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Hero(
                              tag: 'signinBtn',
                              child: PharmacyButton(
                                onPressed: () => Get.toNamed("/signin"),
                                text: "Sign In",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Builder(builder: (context) {
                      String selectedValue = "drug";
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButton(
                            isExpanded: true,
                            hint: const Text("Category"),
                            value: selectedValue,
                            items: const [
                              DropdownMenuItem(
                                value: 'drug',
                                child: Text("Drug"),
                              ),
                              DropdownMenuItem(
                                value: 'shower',
                                child: Text("Shower"),
                              ),
                              DropdownMenuItem(
                                value: 'kids',
                                child: Text("Kids"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(
                                () {
                                  print(value);
                                  selectedValue = value!;
                                },
                              );
                            },
                          );
                        },
                      );
                    }),
                    const Divider(color: Colors.white70),
                    MenuItem(
                      text: 'Notifications',
                      icon: Icons.notifications_outlined,
                      onClicked: () => selectedItem(context, 5),
                    ),
                    MenuItem(
                      text: 'Settings',
                      icon: Icons.settings,
                      onClicked: () => selectedItem(context, 6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Scaffold(), // Page 1
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Scaffold(), // Page 2
        ));
        break;
    }
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onClicked;

  const MenuItem({
    required this.text,
    required this.icon,
    this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.black;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: context.textTheme.bodyLarge),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}

class SearchFieldDrawer extends StatelessWidget {
  const SearchFieldDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return TextField(
      style: const TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(
          Icons.search,
          color: color,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
