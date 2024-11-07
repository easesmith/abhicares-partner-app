// import 'package:abhicares_main/main_tab.dart';
import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:abhicaresservice/screens/authentication/singup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main_tab.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  String phone = '';
  bool _valEmpty = false;
  bool otpGenrated = false;
  final GlobalKey<FormState> _loginKey = GlobalKey();
  final textField = TextEditingController();
  final _otpController = OtpFieldController();

  bool _isloginLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/abhicares_partner.png',
              height: 150,
            ),
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Form(
                    key: _loginKey,
                    child: Column(
                      children: [
                        otpGenrated
                            ? OTPTextField(
                                controller: _otpController,
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: 30,
                                style: TextStyle(fontSize: 14),
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.underline,
                                onChanged: (pin) {
                                  print("Changed: " + pin);
                                },
                                onCompleted: (pin) async {
                                  setState(() {
                                    _isloginLoading = true;
                                  });
                                  var response = await ref
                                      .watch(UserProvider.notifier)
                                      .login(phone.replaceAll(' ', ''), pin);

                                  if (response['error'] == "Invalid Otp") {
                                    setState(() {
                                      _isloginLoading = false;
                                    });
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                              "Invalid OTP",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('ok'),
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    setState(() {
                                      otpGenrated = true;
                                      _isloginLoading = false;
                                    });
                                    // Navigator.pushReplacementNamed(
                                    //   context,
                                    //   MainTabsScreen.routeName,
                                    //   arguments: 0,
                                    // );
                                  }
                                  print("Completed: " + pin);
                                },
                              )
                            : TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(10),
                                  PhoneNumberFormatter(),
                                ],
                                controller: textField,
                                decoration: const InputDecoration(
                                  hintText: 'Mobile Number',
                                  prefixIcon: Icon(
                                    Icons.call,
                                    color: Colors.grey,
                                  ),
                                  prefixText: '+91 ',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (val) {
                                  phone = val;
                                },
                                onSaved: (val) {
                                  phone = val!;
                                },
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        _valEmpty
                            ? const Text(
                                "Enter a valid 10 digit Number",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: _isloginLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : otpGenrated
                                  ? Container(
                                      height: 100,
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "OTP sent on +91 $phone",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          OtpTimerButton(
                                            height: 60,
                                            onPressed: () async {
                                              setState(() {
                                                _isloginLoading = true;
                                              });
                                              var response = await ref
                                                  .watch(UserProvider.notifier)
                                                  .loginOtp(phone.replaceAll(
                                                      ' ', ''));
                                              setState(() {
                                                _isloginLoading = false;
                                                _otpController.clear();
                                              });
                                            },
                                            text: const Text(
                                              'Resend OTP',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue,
                                                // decoration:
                                                //     TextDecoration.underline,
                                                // decorationColor: Colors.blue,
                                              ),
                                            ),
                                            buttonType: ButtonType.text_button,
                                            backgroundColor: Colors.orange,
                                            duration: 60,
                                          ),
                                        ],
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        if (phone == "" || phone.length != 11) {
                                          setState(() {
                                            _valEmpty = true;
                                          });
                                        } else {
                                          setState(() {
                                            _valEmpty = false;
                                            _isloginLoading = true;
                                          });
                                          var response = await ref
                                              .watch(UserProvider.notifier)
                                              .loginOtp(
                                                  phone.replaceAll(' ', ''));

                                          if (response['error'] == "NOUSER") {
                                            setState(() {
                                              _isloginLoading = false;
                                            });
                                            return showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                      "No Account found by +91$phone",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    actions: [
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('ok'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            setState(() {
                                              otpGenrated = true;
                                              _isloginLoading = false;
                                            });
                                            // Navigator.pushReplacementNamed(
                                            //   context,
                                            //   MainTabsScreen.routeName,
                                            //   arguments: 0,
                                            // );
                                          }
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SingUpScreen(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Join Us !',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 5 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
