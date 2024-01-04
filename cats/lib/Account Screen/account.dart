import 'package:cats/Account%20Screen/widget/setting_items.dart';
import 'package:cats/Account%20Screen/widget/setting_switch.dart';
import 'package:cats/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null, // Set the leading widget to null
        automaticallyImplyLeading: false, // Geri tuşunu gizle
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset("assets/avatar.png", width: 70, height: 70),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CAT's",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Surface Anomoliy Detection",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              SettingItem(
                title: "Language",
                icon: Ionicons.earth,
                bgColor: Colors.orange.shade100,
                iconColor: Colors.orange,
                value: "Türkçe",
                onTap: () {},
              ),
              SizedBox(height: 20),
              SettingItem(
                title: "Notifications",
                icon: Ionicons.notifications,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {
                  _showNotificationDialog(context);
                },
              ),
              SizedBox(height: 20),
              SettingSwitch(
                title: "Dark Mode",
                icon: Ionicons.earth,
                bgColor: Colors.purple.shade100,
                iconColor: Colors.purple,
                value: isDarkMode,
                onTap: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              SizedBox(height: 20),
              SettingItem(
                title: "Help",
                icon: Ionicons.nuclear,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () {
                  _showConfirmationDialog(context);
                },
              ),
              SizedBox(height: 20),
              SettingItem(
                title: "Quit",
                icon: Icons.exit_to_app,
                bgColor: Colors.green.shade100,
                iconColor: Colors.green,
                onTap: () {
                  _handleQuit(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Url Yönlendirme Sayfası İşlemleri
_showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Redirect"),
        content: Text("Do you want to redirect to the CAT's website?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dialog kapat
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              _launchURL("https://flutter.dev");
              Navigator.of(context).pop(); // Dialog kapat
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}

// Url İşlemleri
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//Bildirim İşlemleri
void _showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Allow Notifications"),
        content: Text("Do you want to receive notifications from the app?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Diyalog kutusunu kapat
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}

//Çıkış İşlemleri
void _handleQuit(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => WelcomeScreen()),
  );
}
