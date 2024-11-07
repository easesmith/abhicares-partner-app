import 'package:abhicaresservice/data/categories.dart';
import 'package:abhicaresservice/provider/data_provider.dart';
import 'package:abhicaresservice/provider/user_provider.dart';
import 'package:abhicaresservice/screens/main_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingUpScreen extends ConsumerStatefulWidget {
  const SingUpScreen({super.key});

  @override
  ConsumerState<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends ConsumerState<SingUpScreen> {
  final _singupForm = GlobalKey<FormState>();
  List services = [];
  bool servicesLoading = false;
  bool categoryError = false;
  bool servicesError = false;
  bool _isLoading = false;
  List categories = categoriesData;
  String? seLectedCategory;
  Future<void> LoadServices(String catId) async {
    var result =
        await ref.read(DataProvider.notifier).getServices(catId);
    print(result);
    if (result == []) {
    } else {
      if (mounted) {
        setState(() {
          servicesLoading = false;
          services = result;
        });
      }
    }
  }

  var serviceman = {
    "name": "",
    "legalName": '',
    "phone": "",
    "gst": "",
    "addressLine": "",
    "city": "",
    "state": "",
    "pincode": "",
  };

  List selectedServices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 50,
                            ),
                          ),
                          const Text(
                            "Join Us",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Enter your Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _singupForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fieldBox(
                            label: "Name",
                            validator: (val) {
                              if (val == "" || val!.isEmpty) {
                                return "Field can not be empty";
                              }
                              return null;
                            },
                            onchanged: (val) => serviceman['name'] = val,
                          ),
                          fieldBox(
                            label: "Phone ",
                            prefix: '+91 ',
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            validator: (val) {
                              if (val!.length != 10 || val.isEmpty) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                            onchanged: (val) => serviceman['phone'] = val,
                          ),
                          fieldBox(
                            label: "Legal Name (optional)",
                            onchanged: (val) => serviceman['legalName'] = val,
                          ),
                          fieldBox(
                            label: "Gst number (optional)",
                            onchanged: (val) => serviceman['gst'] = val,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Address",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          fieldBox(
                            label: "Address Line",
                            validator: (val) {
                              if (val == "" || val!.isEmpty) {
                                return "Field can not be empty";
                              }
                              return null;
                            },
                            onchanged: (val) => serviceman['addressLine'] = val,
                          ),
                          fieldBox(
                            label: "City",
                            validator: (val) {
                              if (val == "" || val!.isEmpty) {
                                return "Field can not be empty";
                              }
                              return null;
                            },
                            onchanged: (val) => serviceman['city'] = val,
                          ),
                          fieldBox(
                            label: "State",
                            validator: (val) {
                              if (val == "" || val!.isEmpty) {
                                return "Field can not be empty";
                              }
                              return null;
                            },
                            onchanged: (val) => serviceman['state'] = val,
                          ),
                          fieldBox(
                            label: "Pincode",
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(6),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            validator: (val) {
                              if (val!.length != 6 || val.isEmpty) {
                                return "Enter a valid pincode";
                              }
                              return null;
                            },
                            onchanged: (val) => serviceman['pincode'] = val,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            hint: const Text("Select your category"),
                            decoration: InputDecoration(
                              label: const Text('Select Category'),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            items: categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Text(
                                      category.categoryName,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) async {
                              print(val);
                              seLectedCategory = val as String;
                              setState(() {
                                categoryError = false;
                                selectedServices = [];
                                servicesLoading = true;
                                services = [];
                                servicesError = false;
                              });
                              await LoadServices(val);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          categoryError
                              ? const Text(
                                  "Select an category",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox(),
                          servicesLoading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 50,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox(
                                  height: 20,
                                ),
                          services.isEmpty
                              ? const SizedBox()
                              : const Text(
                                  "Select Service you want serve",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                          ...services
                              .map((service) => ListTile(
                                    title: Text(service['name']),
                                    trailing: Checkbox(
                                      value: selectedServices
                                          .contains(service['_id']),
                                      onChanged: (val) {
                                        if (!val!) {
                                          setState(() {
                                            selectedServices
                                                .remove(service['_id']);
                                          });
                                        } else {
                                          setState(() {
                                            selectedServices
                                                .add(service['_id']);
                                            servicesError = false;
                                          });
                                        }
                                        print(selectedServices);
                                      },
                                    ),
                                  ))
                              ,
                          servicesError
                              ? const Text(
                                  "Select an Service to serve",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_singupForm.currentState!.validate() ||
                                    selectedServices.isEmpty ||
                                    seLectedCategory == null) {
                                  print(_singupForm.currentState!.validate());
                                  if (seLectedCategory == null) {
                                    setState(() {
                                      categoryError = true;
                                    });
                                  } else if (selectedServices.isEmpty) {
                                    setState(() {
                                      servicesError = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  ref.watch(UserProvider.notifier).signup(
                                        phone: serviceman['phone']!,
                                        name: serviceman['name']!,
                                        legalName: serviceman['legalName']!,
                                        gst: serviceman['gst']!,
                                        addressLine: serviceman['phone']!,
                                        pincode: serviceman['pincode']!,
                                        state: serviceman['state']!,
                                        city: serviceman['city']!,
                                        catId: seLectedCategory!,
                                        services: services,
                                      );
                                }
                                _singupForm.currentState!.validate();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainTabsScreen()),
                                    (route) => false);
                              },
                              child: const Text('Signup'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }

  Widget fieldBox({
    required String label,
    String? prefix,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required Function onchanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: TextFormField(
        onChanged: (val) => onchanged(val),
        validator: validator ?? (val) {
          return null;
        },
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters ?? [],
        decoration: InputDecoration(
          label: Text(label),
          prefix: Text(prefix ?? ''),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
