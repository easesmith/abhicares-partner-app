import 'package:abhicaresservice/screens/pages/booking_info_screen.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.id,
    required this.value,
    this.bookingDate,
    required this.bookingTime,
    this.address,
  });

  final String id;
  final int value;
  final String? bookingDate;
  final String bookingTime;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingInfoScreen(
              id: id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
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
          vertical: 5,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#$id',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₹ $value',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (bookingDate != null)
              Row(
                children: [
                  const Text(
                    'Booking Date: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    bookingDate ?? '',
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
                const SizedBox(
                  width: 5,
                ),
                Text(
                  bookingTime,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (address != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Address: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 220,
                    child: Text(
                      address ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
