import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:abhicaresservice/screens/authentication/authentication_screen.dart';
import 'package:abhicaresservice/screens/main_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(UserProvider);
    return MaterialApp(
      title: 'Abhicares Partner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ref.watch(UserProvider.notifier).isAuth
          ? const MainTabsScreen()
          : FutureBuilder(
              future: ref.watch(UserProvider.notifier).tryAutoLogin(),
              builder: (context, authresultSnapshot) =>
                  authresultSnapshot == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const AuthenticationScreen(),
            ),
      routes: {
        MainTabsScreen.routeName: (context) => const MainTabsScreen(),
      },
    );
  }
}
