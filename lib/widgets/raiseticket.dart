import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:abhicaresservice/screens/pages/helpcentre_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RaiseTicket extends ConsumerStatefulWidget {
  const RaiseTicket({super.key});

  @override
  ConsumerState<RaiseTicket> createState() => _RaiseTicketState();
}

class _RaiseTicketState extends ConsumerState<RaiseTicket> {
  final issueController = TextEditingController();
  final descriptionController = TextEditingController();

  void Summision() {
    final String EnteredIssueName = issueController.text;
    final String EnteredDescription = descriptionController.text;

    print(EnteredIssueName);
    print(EnteredDescription);

    if (EnteredDescription.isEmpty || EnteredDescription.isEmpty) {
      return;
    } else {
      ref.watch(UserProvider.notifier).postRaiseTicket(
            issue: EnteredIssueName,
            description: EnteredDescription,
          );

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Issue name',
              ),
              controller: issueController,
              onSubmitted: (_) => Summision(),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              controller: descriptionController,
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
                onPressed: Summision,
                child: const Text(
                  'Raise Ticket',
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
}
