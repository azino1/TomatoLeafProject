import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomato_leave_virus_mobile/data.dart';
import 'package:tomato_leave_virus_mobile/providers/language_provider.dart';

import '../models/plant.dart';

class VirusDetailPage extends ConsumerStatefulWidget {
  static const routeName = "/viruspage";
  final Plant plant;
  const VirusDetailPage({super.key, required this.plant});

  @override
  ConsumerState<VirusDetailPage> createState() => _VirusDetailPageState();
}

class _VirusDetailPageState extends ConsumerState<VirusDetailPage> {
  late Map<String, dynamic> virusDesJson;
  List dataFile = [];

  @override
  void initState() {
    final isHause = ref.read(isHausa);
    if (isHause) {
      dataFile = hausaInfo;
    } else {
      dataFile = englishInfo;
    }

    final index = dataFile.indexWhere(
        (element) => element['virusName'].contains(widget.plant.virusName));

    if (index != -1) {
      virusDesJson = dataFile[index];
    }
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
          return Column(
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
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
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
              const SizedBox(
                height: 15,
              ),
              Text(isHause ? "shuka Sunan" : "plant Name"),
              const SizedBox(
                height: 5,
              ),
              Text(isHause ? "Tumatir" : widget.plant.plantName),
              const SizedBox(
                height: 15,
              ),
              Text(isHause ? "Cutar da aka gano" : "Detected Disease:"),
              const SizedBox(height: 5),
              Text(virusDesJson['virusName']),
              const SizedBox(height: 15),
              Text(isHause ? "TAV watsawa" : "TAV transmission:"),
              const SizedBox(
                height: 5,
              ),
              Text(virusDesJson['TAVtransmission']),
              const SizedBox(
                height: 15,
              ),
              Text(isHause ? "Gudanar da TAV" : "TAV Management"),
              const SizedBox(
                height: 5,
              ),
              ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(index.toString()),
                      title: Text(virusDesJson["TAVmanagement"][index]),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: virusDesJson["TAVmanagement"].length),
            ],
          );
        }),
      ),
    );
  }
}
