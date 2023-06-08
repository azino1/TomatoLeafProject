import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';

import '../models/plant.dart';

class VirusDetailPage extends StatefulWidget {
  static const routeName = "/viruspage";
  final Plant plant;
  const VirusDetailPage({super.key, required this.plant});

  @override
  State<VirusDetailPage> createState() => _VirusDetailPageState();
}

class _VirusDetailPageState extends State<VirusDetailPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: deviceSize.height * 0.07,
            ),
            InkWell(
              //takes the user to the previous screen
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(241, 245, 249, 1)),
                child: Icon(
                  Icons.close,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Diseases Detection Result",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              height: 88,
              width: 132,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(widget.plant.localPlantImage!),
                      fit: BoxFit.cover)),
            ),
            Center(
              child: Text(widget.plant.virusName),
            ),
          ],
        ),
      ),
    );
  }
}
