import 'package:abhicaresservice/helper/back_Services.dart';
import 'package:abhicaresservice/helper/googlemapapi.dart';
import 'package:abhicaresservice/helper/server_url.dart';
import 'package:abhicaresservice/provider/booking_provider.dart';
import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingInfoScreen extends ConsumerStatefulWidget {
  final id;
  const BookingInfoScreen({super.key, required this.id});

  @override
  ConsumerState<BookingInfoScreen> createState() => _BookingInfoScreenState();
}

class _BookingInfoScreenState extends ConsumerState<BookingInfoScreen> {
  Map data = {};
  var isloading = true;
  var user;
  String loadingText = '';
  Future<void> _loadPage() async {
    var result = await ref
        .watch(bookingProvider.notifier)
        .getBooking(bookingId: widget.id);
    var useresult = ref.read(UserProvider.notifier).getUser;
    print(result);
    if (result == {}) {
    } else {
      if (mounted) {
        setState(() {
          isloading = false;
          data = result;
          user = useresult;
        });
      }
    }
  }

  Future<void> updateStatus() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
  }

  startService() async {
    setState(() {
      loadingText = 'Satrting the service...';
      isloading = true;
    });
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print(currentPosition.latitude);
    print(currentPosition.longitude);
    var result = await ref.watch(bookingProvider.notifier).startBooking(
          bookingId: widget.id,
          lat: currentPosition.latitude,
          long: currentPosition.longitude,
        );
    print(result);
    if (result == {}) {
    } else {
      // WidgetsFlutterBinding.ensureInitialized();
      await initializeService();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingInfoScreen(id: widget.id),
          ));
    }
  }

  reachedOnLocation() async {
    setState(() {
      loadingText = 'updating service status...';
      isloading = true;
    });
    FlutterBackgroundService().invoke("stopService");
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    var result = await ref.watch(bookingProvider.notifier).reachedOnTheLocation(
        bookingId: widget.id,
        lat: currentPosition.latitude,
        long: currentPosition.longitude);
    if (result == {}) {
    } else {
      // WidgetsFlutterBinding.ensureInitialized();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingInfoScreen(id: widget.id),
          ));
    }
  }

  completeBookingReq() async {
    setState(() {
      loadingText = 'updating service status...';
      isloading = true;
    });
    var result = await ref.watch(bookingProvider.notifier).completeBookingReq(
          bookingId: widget.id,
        );
    if (result == {}) {
    } else {
      // WidgetsFlutterBinding.ensureInitialized();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingInfoScreen(id: widget.id),
          ));
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
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          Duration(seconds: 10),
          () async {
            var result = await ref
                .watch(bookingProvider.notifier)
                .getBooking(bookingId: widget.id);
            var useresult = ref.read(UserProvider.notifier).getUser;
            print(result);
            if (result == {}) {
            } else {
              if (mounted) {
                setState(() {
                  isloading = false;
                  data = result;
                  user = useresult;
                });
              }
            }

            // showing snackbar
            // .showSnackBar(
            //   SnackBar(
            //     content: const Text('Page Refreshed'),
            //   ),
            // );
          },
        );
      },
      child: Scaffold(
        body: isloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      strokeWidth: 5,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      loadingText,
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '#${data['_id']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Order value: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${data['orderValue']}',
                              style: const TextStyle(
                                color: Colors.green,
                                // fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Booking Date: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${data['bookingDate']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Booking Time: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${data['bookingTime']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Address: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                '${data['userAddress']['addressLine']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   children: [
                        //     const Text(
                        //       'Status: ',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           color: Colors.deepPurple,
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //         padding: const EdgeInsets.symmetric(
                        //           vertical: 5,
                        //           horizontal: 10,
                        //         ),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           '${data['status']}',
                        //           style: const TextStyle(
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (user['status'] == 'offline')
                          const SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                              child: Text(
                                "You are currently Offline",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        if (user['status'] == 'online')
                          data['currentLocation']['status'] == 'completeReq'
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                      child: Text(
                                          "Waiting for Customer Approval")),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () => data['status'] == "started"
                                        ? data['currentLocation']['status'] ==
                                                "reached"
                                            ? completeBookingReq()
                                            : reachedOnLocation()
                                        : startService(),
                                    child: Text(
                                      data['status'] == "started"
                                          ? data['currentLocation']['status'] ==
                                                  "reached"
                                              ? "complete the service"
                                              : 'Reached on the location'
                                          : 'Start Service',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        const SizedBox(
                          height: 20,
                        ),
                        data['currentLocation']['status'] == "out-of-delivery"
                            ? Container(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await launchUrl(Uri.parse(
                                        'google.navigation:q=${data['userAddress']['location']['coordinates'][0]}, ${data['userAddress']['location']['coordinates'][1]}&key=${GoogleMapApi.API_KEY}'));
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.map),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Open Maps"),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        data['currentLocation']['status'] == "reached"
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Customer Information',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'User',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(data['userId']['name'])
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Phone',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(data['userId']['phone'])
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const Text(
                          'Service Booked ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: data['package'] != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data['package']['name']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Text(
                                      'Package',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'Included services',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ...data['package']['products'].map(
                                      (prod) {
                                        print(prod);
                                        return packageProd(prod);
                                      },
                                    ).toList()
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: double.infinity,
                                      child: Image.network(
                                        '${ServerUrl.image_URL}${data['product']['imageUrl'][0]}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data['product']['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹ ${data['product']['offerPrice']}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Quantity: ${data['quantity']}',
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        width: 200,
                                        child: Html(
                                            data: data['product']
                                                ['description']))
                                  ],
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Container packageProd(prod) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      color: Colors.grey[200],
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image.network(
              '${ServerUrl.image_URL}${prod['productId']["imageUrl"][0]}',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            child: Text(
              prod['productId']['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
