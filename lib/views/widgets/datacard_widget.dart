import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:tomato_leave_virus_mobile/models/plant.dart';

import '../../constant.dart';
import '../../helpers/api_call.dart';
import '../../providers/language_provider.dart';
import '../../providers/plant_data_provider.dart';
import '../virus_detail_page.dart';

class DataCard extends ConsumerStatefulWidget {
  final Plant plant;
  const DataCard({super.key, required this.plant});

  @override
  ConsumerState<DataCard> createState() => _DataCardState();
}

class _DataCardState extends ConsumerState<DataCard> {
  bool isScanningLocal = false;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isHause = ref.watch(isHausa);
    return InkWell(
      onTap: () async {
        if (widget.plant.plantName.toLowerCase() ==
                "Unknown plant".toLowerCase() &&
            widget.plant.isPending) {
          isHause
              ? showUpMessage(
                  context,
                  "Shuka yana dubawa, da fatan za a jira. Ana dubawa zai iya ɗaukar har zuwa mintuna 5",
                  "Sanarwa!")
              : showUpMessage(
                  context,
                  "Plant is scanning, please wait. Scanning could take up to 5 minutes",
                  "Notice!");
          await sendLocalImageforAnalysis(widget.plant);
          return;
        }
        if (widget.plant.healthStatus != 1) {
          isHause
              ? showUpMessage(
                  context,
                  "Ganyen yana da lafiya ko kuma wani abu ne da ba a sani ba",
                  'Fadakarwa')
              : showUpMessage(context,
                  "The leaf is healthy or it is an unknown object", 'Alert');

          return;
        }

        final viruses = ref.read(plantsProvider).virusList;

        final index = viruses.indexWhere((element) {
          print("element ${element.name.toLowerCase()}");
          print(
              "virus ${widget.plant.virusName.toLowerCase().replaceAll("_", "")}");
          return element.name.toLowerCase().replaceAll("_", "").contains(
              widget.plant.virusName.toLowerCase().replaceAll("_", ""));
        });
        if (index != -1) {
          context.push(VirusDetailPage.routeName, extra: widget.plant);
        } else {
          isHause
              ? showUpMessage(
                  context,
                  "Ganyen yana da lafiya ko kuma wani abu ne da ba a sani ba",
                  'Fadakarwa')
              : showUpMessage(context,
                  "The leaf is healthy or it is an unknown object", 'Alert');
        }
        print("inde $index");
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(builder: (context, ref, child) {
              final isHause = ref.watch(isHausa);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 220,
                    child: Text(
                        isHause
                            ? widget.plant.plantName ==
                                    "Healthy Leaf / Unknown plant"
                                ? "Lafiyayyan Leaf / Ba a sani ba shuka"
                                : widget.plant.plantName ==
                                        "Tomato Leaf with Virus"
                                    ? "Ganyen Tumatir mai Virus"
                                    : "Ba a sani ba shuka"
                            : widget.plant.plantName,
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  isScanningLocal
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: primaryColor,
                          ),
                        )
                      : Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: widget.plant.isPending
                                      ? const Color(0xffF4CE6B)
                                      : Colors.greenAccent),
                              child: !widget.plant.isPending
                                  ? isHause
                                      ? const Text('Yi')
                                      : const Text('Done')
                                  : isHause
                                      ? const Text('jiran')
                                      : const Text('Pending'),
                            ),
                            const SizedBox(width: 15),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        )
                ],
              );
            }),
            const SizedBox(height: 5),
            Text(DateFormat.yMd().format(widget.plant.time))
          ],
        ),
      ),
    );
  }

  ///resend the locally saved image to the ML model.
  Future<void> sendLocalImageforAnalysis(Plant plant) async {
    bool result = await InternetConnectionChecker().hasConnection;
    final isHause = ref.read(isHausa);
    if (!result) {
      if (mounted) {
        isHause
            ? errorUpMessage(context,
                'Babu Intanet. Za mu adana hotonku a gida', 'Fadakarwa')
            : errorUpMessage(context,
                'No Internet.. We will save your image locally', 'Alert');
        await Future.delayed(const Duration(seconds: 1));
      }
    } else {
      if (plant.localPlantImage == null) return;

      setState(() {
        isScanningLocal = true;
      });
      try {
        // Get the temporary directory
        Directory tempDir = Directory.systemTemp;

        // Create a File object in the temporary directory
        File file = File('${tempDir.path}/file.jpeg');
        final newFile = await file.writeAsBytes(plant.localPlantImage!);

        // final filePath = File.fromRawPath(plant.localPlantImage!).path;
        final scanningResult =
            await ApiServices.predictPlantDisease(newFile.path);

        final int healthStatus =
            scanningResult.toLowerCase().contains("healthy")
                ? 0
                : scanningResult.toLowerCase().contains("tomato")
                    ? 1
                    : 2;
        await ref
            .read(plantsProvider)
            .updateAnalysedLocalPlant(plant.id, healthStatus, scanningResult);
      } catch (e) {
        print(e);
      }

      setState(() {
        isScanningLocal = false;
      });
    }
  }
}
