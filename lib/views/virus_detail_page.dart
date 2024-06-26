import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomato_leave_virus_mobile/data.dart';
import 'package:tomato_leave_virus_mobile/providers/language_provider.dart';

import '../constant.dart';
import '../models/plant.dart';
import '../models/virus_model.dart';
import '../providers/plant_data_provider.dart';

class VirusDetailPage extends ConsumerStatefulWidget {
  static const routeName = "/viruspage";
  final Plant plant;
  const VirusDetailPage({super.key, required this.plant});

  @override
  ConsumerState<VirusDetailPage> createState() => _VirusDetailPageState();
}

class _VirusDetailPageState extends ConsumerState<VirusDetailPage> {
  late Virus _virus;
  String language = "english";

  @override
  void initState() {
    final isHause = ref.read(isHausa);
    if (isHause) {
      language = "hausa";
    } else {}

    final viruses = ref.read(plantsProvider).virusList;

    final index = viruses.indexWhere((element) {
      print(element.language);
      return element.name.toLowerCase().replaceAll("_", "").contains(
              widget.plant.virusName.toLowerCase().replaceAll("_", "")) &&
          element.language.toLowerCase() == language.toLowerCase();
    });

    if (index != -1) {
      setState(() {
        _virus = viruses[index];
      });
    }
    print("index:... $index");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(builder: (context, ref, child) {
          final isHause = ref.watch(isHausa);
          return SingleChildScrollView(
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
                Text(
                  isHause
                      ? "Sakamakon Gano Cututtuka"
                      : "Diseases Detection Result",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 24),
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
                // const SizedBox(
                //   height: 15,
                // ),
                // Text(
                //   isHause ? "shuka Sunan" : "plant Name",
                //   style: const TextStyle(color: hintTextColor, fontSize: 16),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                // Text(
                //   isHause ? "Tumatir" : widget.plant.plantName,
                //   style: const TextStyle(fontSize: 19),
                // ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  isHause ? "Cutar da aka gano" : "Detected Disease:",
                  style: const TextStyle(color: hintTextColor, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  _virus.name,
                  style: const TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 15),
                Text(
                  isHause ? "TAV watsawa" : "TAV Transmission:",
                  style: const TextStyle(color: hintTextColor, fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  _virus.transmission,
                  style: const TextStyle(fontSize: 19),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  isHause ? "Gudanar da TAV" : "TAV Management",
                  style: const TextStyle(color: hintTextColor, fontSize: 16),
                ),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text((index + 1).toString()),
                        title: Text(_virus.management[index]),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: _virus.management.length),
              ],
            ),
          );
        }),
      ),
    );
  }
}
