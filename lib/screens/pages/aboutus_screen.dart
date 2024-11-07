import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("About Us"),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: const TextSpan(
                    text:
                        'AbhiCares is Mithilas\'s largest online home services platform. Launched in 2022, AbhiCares today operates in Darbhanga. The platform helps customers book reliable & high quality services like – Home repair, Beauty treatment, Massages, Haircuts, Handyman, Appliance repair, painting, carpentry, event management & planner , Business & tax consultancy and many more - delivered by trained professionals conveniently at home. AbhiCares vision is to empower millions of professionals indiawide to deliver services at home like never experienced before.\n\n',
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'Abhicares stands as a beacon of professionalism and reliability in the on-demand service industry. Dedicated to providing an extensive range of services—from home care and painting to specialized services like makeup, plumbing, carpentry, personal care, appliance repair, and CCTV installation—Abhicares ensures quality and efficiency in every job they undertake. What truly sets them apart is their commitment to connecting users with proficient servicemen, ensuring not just the fulfillment of a task, but the promise of excellence. In an era where time is invaluable, Abhicares has made it their mission to offer prompt solutions, taking the hassle out of daily chores and needs.\n\n',
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        text: " Why choose us \n\n",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "1. Professionals at your doorstep: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "AbhiCares brings you the Professionals in Darbhanga, Bihar at your home. All professionals are background verified. They go through a number of security checks before they are brought on board.\n",
                      ),
                      TextSpan(
                        text: "2. Doorstep Repair: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "You get a doorstep repair within 90 minutes from the best professionals services in Darbhanga, Bihar.\n",
                      ),
                      TextSpan(
                        text: "3. Post-service guarantee: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "When you avail the services in Darbhanga, Bihar from AbhiCares, you get a 30-day post service guarantee, T&C apply.\n",
                      ),
                      TextSpan(
                        text: "4. Re-work Assurance: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "AbhiCares strives to offer top quality services for you and your home every time. If you're not satisfied with the quality of the service, we'll get a rework done to your satisfaction at no extra charge, T&C apply.\n",
                      ),
                      TextSpan(
                        text: "4. Re-work Assurance: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "AbhiCares strives to offer top quality services for you and your home every time. If you're not satisfied with the quality of the service, we'll get a rework done to your satisfaction at no extra charge, T&C apply.\n",
                      ),
                      TextSpan(
                        text: "5. Customer Centric: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "All the services provided by AbhiCares, services in Darbhanga, Bihar are customer-centric.\n",
                      ),
                      TextSpan(
                        text: "5. Professional Support: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Want to get in touch with us directly to express a concern or have some queries that need immediate responses? Chat with us, write us an email or even call us to get through to our round-the-clock support team that's already ready to go that extra mile for your happiness.\n\n\n",
                      ),
                      TextSpan(
                        text: "Address\n ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "C/O-SHYAM BIHARI SAH-KHASRA NO.1288;1289; VILL/TOLA/PANCH-TARALAHI; BAHADURPUR; Darbhanga; Bihar; 846003\n",
                      ),
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
    );
  }
}
