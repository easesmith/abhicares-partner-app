import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:abhicaresservice/widgets/raiseticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HelpCenterScreen extends ConsumerStatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  ConsumerState<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends ConsumerState<HelpCenterScreen> {
  void _showAddNewAddress(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return const RaiseTicket();
      },
    );
  }

  var isloading = true;
  List tickets = [];

  Future<void> _loadPage() async {
    var result = await ref.read(UserProvider.notifier).getuserTickets();
    print(result);
    if (result == []) {
    } else {
      if (mounted) {
        setState(() {
          isloading = false;
          tickets = result;
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
    print(tickets);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: isloading
            ? const SizedBox()
            : CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black,
                child: IconButton(
                    onPressed: () {
                      _showAddNewAddress(context);
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
        appBar: AppBar(
          title: const Text("Help centre"),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : tickets.isEmpty
                ? const Center(child: Text("No Tickets raised !"))
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, index) => TicketCard(
                        issue: tickets[index]['issue'],
                        description: tickets[index]['description'],
                        raiseDate: tickets[index]['createdAt'],
                        id: tickets[index]['_id'],
                        status: tickets[index]['status'],
                      ),
                      itemCount: tickets.length,
                    ),
                  ),
      ),
    );
  }

  Widget TicketCard(
      {required String issue,
      required String description,
      required String raiseDate,
      required String status,
      required String id}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "# $id",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "issue:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            issue,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const Text(
            "desc:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 14
                // fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              const Text(
                "raise date:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                DateFormat.yMMMd().format(DateTime.parse(raiseDate)),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              const Text(
                "Status:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
