import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../constant.dart';

class NewCaptureScreen extends StatefulWidget {
  static const routeName = "/new-captured";
  const NewCaptureScreen({super.key});

  @override
  State<NewCaptureScreen> createState() => _NewCaptureScreenState();
}

class _NewCaptureScreenState extends State<NewCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 300,
      //   backgroundColor: primaryColor,
      //   title: const Text('Welcome, Chief Hassen'),
      //   actions: [
      //     DropdownButton(items: const [
      //       DropdownMenuItem(child: Text('English')),
      //     ], onChanged: (val) {})
      //   ],
      // ),
      body: Column(
        children: [
          customAppBar(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Previous Results',
                style: TextStyle(color: primaryColor, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return dataCard();
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: 12),
          ),
          const SizedBox(height: 20),
          Text('Click here to take a photo of the plant'),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "New Capture",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget dataCard() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Leaf name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xffF4CE6B)),
                    child: Text('Pending'),
                  ),
                  const SizedBox(width: 25),
                  const Icon(Icons.arrow_forward_ios)
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          const Text('12:00 pm')
        ],
      ),
    );
  }

  Widget customAppBar() {
    final primaryColor = Theme.of(context).primaryColor;
    final sizeDevice = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      height: sizeDevice.height * 0.22,
      decoration: BoxDecoration(color: primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Welcome, Chief Hassen',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DropdownButton(
                underline: null,
                borderRadius: BorderRadius.circular(8),
                iconSize: 20,
                items: const [
                  DropdownMenuItem(
                      child: Text('English',
                          style: TextStyle(color: Colors.white, fontSize: 12))),
                ],
                onChanged: (val) {}),
          )
        ],
      ),
    );
  }
}
