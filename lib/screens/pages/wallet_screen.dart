import 'package:abhicaresservice/provider/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  final cashoutValueController = TextEditingController();

  List cashoutList = [];
  Map wallet = {};

  var isloading = true;

  var _validate = false;
  Future<void> _loadPage() async {
    var walletResult =
        await ref.watch(sellerWalletProvider.notifier).getWallet();
    var cashoutResult = await ref
        .watch(sellerWalletProvider.notifier)
        .getSellerCashout(id: walletResult['_id']);
    // print(result);
    // print(currentBooking);
    if (walletResult == {}) {
    } else {
      if (mounted) {
        setState(() {
          wallet = walletResult;
          cashoutList = cashoutResult;
          isloading = false;
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

  void Summision() async {
    final int cashoutValue = int.parse(cashoutValueController.text);
    print(cashoutValue);
    if (cashoutValue <= 0) {
      return;
    } else {
      await ref.watch(sellerWalletProvider.notifier).createCashout(
            walletId: wallet['_id'],
            value: cashoutValue,
          );
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WalletScreen()),
      );
    }
  }

  Widget CashoutBottomCard() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Value',
                prefixIcon: const Icon(Icons.currency_rupee),
                errorText: _validate
                    ? "Value Can't Be Empty and more than your balance"
                    : null,
              ),
              keyboardType: TextInputType.number,
              controller: cashoutValueController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: (_) => Summision(),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _validate = cashoutValueController.text.isEmpty;
                  });
                  if (!_validate) {
                    var val = int.parse(cashoutValueController.text);
                    if (val > wallet['balance']) {
                      setState(() {
                        _validate = true;
                      });
                    } else {
                      Summision();
                    }
                  }
                },
                child: const Text(
                  'Cashout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ShowAddCashout(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return CashoutBottomCard();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
      ),
      floatingActionButton: isloading
          ? const SizedBox()
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[500],
              ),
              onPressed: () {
                _ShowAddCashout(context);
              },
              child: const Text(
                'Cash out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '₹${wallet['balance']}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Wallet Id',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '#${wallet['_id']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: ListView.builder(
                        itemBuilder: (context, index) => CashoutCard(
                          value: cashoutList[index]['value'],
                          creationDate: DateFormat.yMMMd().format(
                              DateTime.parse(cashoutList[index]['createdAt'])),
                          cancelledDate: DateFormat.yMMMd().format(
                              DateTime.parse(cashoutList[index]['updatedAt'])),
                          status: cashoutList[index]['status'],
                        ),
                        itemCount: cashoutList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CashoutCard extends StatelessWidget {
  final int value;
  final String creationDate;
  final String cancelledDate;
  final String status;

  const CashoutCard({super.key, 
    required this.value,
    required this.creationDate,
    required this.cancelledDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: status == "created"
            ? Colors.yellow[200]
            : status == "cancelled"
                ? Colors.red[100]
                : Colors.green[100],
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Value",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "₹ $value",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Create Date",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                creationDate,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (status == 'cancelled')
            Row(
              children: [
                const Text(
                  "cancelled Date",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  cancelledDate,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
