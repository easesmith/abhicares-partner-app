import 'package:abhicaresservice/provider/booking_provider.dart';
import 'package:abhicaresservice/widgets/bookingCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class bookingsScreen extends ConsumerStatefulWidget {
  const bookingsScreen({super.key});

  @override
  ConsumerState<bookingsScreen> createState() => _bookingsScreenState();
}

class _bookingsScreenState extends ConsumerState<bookingsScreen> {
  List data = [];
  var isloading = true;
  Future<void> _loadPage() async {
    var result = await ref.watch(bookingProvider.notifier).getUpcomingorders();
    print(result);
    if (result == []) {
    } else {
      if (mounted) {
        setState(() {
          isloading = false;
          data = result;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : data.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index) => BookingCard(
                      id: data[index]['_id'],
                      value: data[index]['orderValue'],
                      bookingDate: data[index]['bookingDate'],
                      bookingTime: data[index]['bookingTime'],
                      address: data[index]['userAddress']['addressLine'],
                    ),
                    itemCount: data.length,
                  ),
                )
              : const Center(
                  child: Text(
                    'No Upcoming Booking!',
                  ),
                ),
    );
  }
}
