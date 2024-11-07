import 'package:abhicaresservice/provider/booking_provider.dart';
import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:abhicaresservice/screens/pages/bookings_screen.dart';
import 'package:abhicaresservice/screens/pages/orderHistory_Screen.dart';
import 'package:abhicaresservice/widgets/bookingCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  List todayBooking = [];
  Map runningBooking = {};
  int walletBalance = 0;
  String addressLine1 = 'Loading....';
  String addressLine2 = 'getting your location....';
  var isloading = true;
  Future<void> _loadPage() async {
    var result = await ref.watch(bookingProvider.notifier).getTodayBooking();
    var currentBooking =
        await ref.watch(bookingProvider.notifier).getRunningBooking();
    // var walletResult =
    //     await ref.watch(sellerWalletProvider.notifier).getWallet();
    if (result == []) {
    } else {
      if (mounted) {
        setState(() {
          todayBooking = result;
          // walletBalance = walletResult['balance'];
          runningBooking = currentBooking;
          isloading = false;
        });
        getCurrentLocation();
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions. Please grant location permission from the setting.')));
      return false;
    }
    return true;
  }

  @override
  void didChangeDependencies() async {
    if (isloading) {
      await _loadPage();
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    List<Placemark> placemark = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = placemark[2];
    // print(place.toString());
    // print('----');
    // print(placemark);
    if (mounted) {
      setState(() {
        addressLine1 = '${place.street}';
        addressLine2 = '${place.subLocality} ${place.locality}';
      });
    }
    // }
  }

// var googleGeocoding = Google
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          child: Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addressLine1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              addressLine2,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Cureent Status",
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                                color: ref
                                            .read(UserProvider.notifier)
                                            .getUser['status'] ==
                                        "offline"
                                    ? Colors.red
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "${ref.read(UserProvider.notifier).getUser['status']}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     const Text("Wallet balance"),
                          //     Text(
                          //       "₹ $walletBalance",
                          //       style: const TextStyle(
                          //         color: Colors.green,
                          //       ),
                          //     ),
                          //     // const SizedBox(
                          //     //   height: 5,
                          //     // ),
                          //     // const Text("working Day"),
                          //     // Text("14"),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        optionBox(
                          name: "Bookings",
                          icon: Icons.online_prediction,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const bookingsScreen(),
                              ),
                            );
                          },
                        ),
                        optionBox(
                          name: "order History",
                          icon: Icons.history,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderHistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Current Order",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    runningBooking.isNotEmpty
                        ? BookingCard(
                            id: runningBooking['_id'],
                            value: runningBooking['orderValue'],
                            bookingTime: runningBooking['bookingTime'],
                            address: runningBooking['userAddress']
                                ['addressLine'],
                          )
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.center,
                            child: const Text("No ongoing order"),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Today Bookings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (todayBooking.isEmpty)
                      Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey[100],
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        width: double.infinity,
                        child:
                            const Center(child: Text("No booking for Today")),
                      ),
                    if (todayBooking.isNotEmpty)
                      ...todayBooking.map((booking) => BookingCard(
                            id: booking['_id'],
                            value: booking['orderValue'],
                            bookingTime: booking['bookingTime'],
                          )),
                  ],
                ),
              ),
            ),
    );
  }
}

class optionBox extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;
  const optionBox({
    required this.name,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            Text(name),
          ],
        ),
      ),
    );
  }
}
