import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:abhicaresservice/screens/authentication/authentication_screen.dart';
import 'package:abhicaresservice/screens/main_tab.dart';
import 'package:abhicaresservice/screens/pages/aboutus_screen.dart';
import 'package:abhicaresservice/screens/pages/comingsoon_screen.dart';
import 'package:abhicaresservice/screens/pages/helpcentre_screen.dart';
import 'package:abhicaresservice/screens/pages/myprofile_screen.dart';
import 'package:abhicaresservice/screens/pages/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(UserProvider.notifier).getUser;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " ${user['name']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "+91 ${user['phone']}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.watch(UserProvider.notifier).ChangeStatus(
                        user['status'] == "offline" ? "online" : "offline",
                      );
                  Navigator.pushReplacementNamed(
                    context,
                    MainTabsScreen.routeName,
                    arguments: 1,
                  );
                },
                child: Text(
                  user['status'] == "offline" ? "Go Online" : "Go Offline",
                ),
              ),
            ),
            const Divider(),
            serviceCard(
              icon: Icons.person,
              serviceName: 'My profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyProfileScreen()),
                );
              },
            ),
            const Divider(),
            serviceCard(
              icon: Icons.info,
              serviceName: 'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutUsScreen()),
                );
              },
            ),
            const Divider(),
            serviceCard(
              icon: Icons.chat,
              serviceName: 'Help Center',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpCenterScreen()),
                );
              },
            ),
            const Divider(),
            serviceCard(
              icon: Icons.account_balance_wallet,
              serviceName: 'My Wallet',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                );
              },
            ),
            const Divider(),
            serviceCard(
              icon: Icons.monetization_on,
              serviceName: 'Refer and Earn',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ComingSoon(
                            screenName: 'Refer and Earn',
                          )),
                );
              },
            ),
            const Divider(),
            serviceCard(
              icon: Icons.star,
              serviceName: 'My Reviews',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ComingSoon(
                            screenName: "My Ratings",
                          )),
                );
              },
            ),
            const Divider(),
            serviceCard(
              icon: Icons.contact_support,
              serviceName: 'Contact Us',
              onTap: () {},
            ),
            const Divider(),
            serviceCard(
              icon: Icons.logout,
              serviceName: 'Logout',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Are you sure You want to logout ?",
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('ok'),
                          ),
                          OutlinedButton(
                              onPressed: () async {
                                await ref.watch(UserProvider.notifier).logout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthenticationScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceCard({
    required IconData icon,
    required String serviceName,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              serviceName,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
