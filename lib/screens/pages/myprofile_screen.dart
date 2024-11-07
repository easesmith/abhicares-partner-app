import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  var user;
  var isloading = true;

  Future<void> _loadPage() async {
    var result = await ref.read(UserProvider.notifier).getUserProfile();
    print(result);
    if (result == {}) {
    } else {
      if (mounted) {
        setState(() {
          isloading = false;
          user = result;
        });
      }
    }
  }

  @override
  void didChangeDependencies() async {
    if (isloading) {
      await _loadPage();
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            const SizedBox(
                              height: 5,
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
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    InfoCard(
                      field: "Legal Name",
                      val: user['legalName'] ?? "Not given",
                    ),
                    InfoCard(
                      field: "Gst Number",
                      val: user['gstNumber'] ?? "Not given",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InfoCard(
                      field: "Address Line",
                      val: user['address']["addressLine"],
                    ),
                    InfoCard(
                      field: "Pincode",
                      val: user['address']["pincode"],
                    ),
                    InfoCard(
                      field: "State",
                      val: user['address']["state"],
                    ),
                    InfoCard(
                      field: "City",
                      val: user['address']["city"],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Category you serve",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purple[50],
                      ),
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        user['categoryId']['name'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget InfoCard({
    required String field,
    required String val,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.purple[100],
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 8,
            ),
            child: Text(
              field,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.purple[50],
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 8,
            ),
            child: Text(
              val,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
