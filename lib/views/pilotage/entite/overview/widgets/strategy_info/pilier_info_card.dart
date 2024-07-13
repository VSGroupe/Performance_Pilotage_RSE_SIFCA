import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perf_rse/utils/i18n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../constants/constant_colors.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../controllers/entite_pilotage_controler.dart';
import 'pilier_model.dart';

class PilierInfoCard extends StatefulWidget {
  final PilierInfoModel info;
  final int annee;
  const PilierInfoCard({super.key, required this.info, required this.annee});

  @override
  State<PilierInfoCard> createState() => _PilierInfoCardState();
}

class _PilierInfoCardState extends State<PilierInfoCard> {

  bool isLoading = false;
  double isHovering = 3;
  Map<String, dynamic> entiteSuivi = {};
  num percentage = 0;

  int status = 0;

  final supabase = Supabase.instance.client;
  final EntitePilotageController entitePilotageController = Get.find();

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final entiteID = entitePilotageController.currentEntite.value;
      final idSuivi = "${entiteID}_${widget.annee}";
      final List suiviDocList = await supabase.from('SuiviData').select().eq("id_suivi",idSuivi);
      final axeId = widget.info.axeId;
      final kEntiteSuivi = suiviDocList.first["suivi_axe"][axeId];
      setState(() {
        entiteSuivi = kEntiteSuivi;
        num kPercentage = (entiteSuivi["indicateur_collectes"] / entiteSuivi["indicateur_total"]) * 100;
        percentage = num.parse(kPercentage.toStringAsFixed(2));
      });
    } catch (e) {
      setState(() {
        status = -1;
      });
    }
    setState(() {
      isLoading = false;
    });

  }


  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: (){},
      onHover: (value){
        if(value){
          setState(() {
            isHovering = 10;
          });
        }else {
          setState(() {
            isHovering =3;
          });
        }
      },
      child: Card(
        elevation: isHovering,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: isLoading ? const Center(
            child: SizedBox(
              width: 50,height: 50, child: CircularProgressIndicator(),
            ),
          ) : (status == -1 ) ?  Center(
            child: SizedBox(
              width: 50,height: 50, child: Text(tr.noData),
            ),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.25),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: widget.info.color!.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset(
                      widget.info.svgSrc!,
                    ),
                  ),
                  Text("$percentage %",style: TextStyle(
                      color: 24 < 30 ?  Colors.red :
                      20 < 60 ? Colors.yellow : percentage < 75 ?
                      Colors.green : Colors.blue,fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              Text(
                widget.info.title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              ProgressLine(
                color: widget.info.color,
                percentage: percentage.toInt(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${entiteSuivi["indicateur_collectes"]} ${tr.indicators}${ entiteSuivi["indicateur_collectes"] > 1 ? "s" : "" } ${tr.on}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black87),
                  ),
                  Text(
                    "${entiteSuivi["indicateur_total"]}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
