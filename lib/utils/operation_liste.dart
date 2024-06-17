import 'package:perf_rse/utils/i18n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OperationList {

      final supabase = Supabase.instance.client;

      String transTypeOperation(String oper){
          switch (oper) {
            case 'Calculé':
                return tr.typeoperation('calculed');
            case 'Primaire':
                return tr.typeoperation('primary');
            case "Test":
              return tr.typeoperation('test');
            default:
              return tr.typeoperation('other');
          }
      }

      String transTypeFormule(String formule){
          switch (formule) {
            case 'Moyenne':
                return tr.typecalcul('average');
            case 'Somme':
                return tr.typecalcul('sum');
            case "Dernier mois renseigné":
              return tr.typecalcul('lastmonth');
            default:
              return tr.typecalcul('other');
          }
    }


    Future<List>getProcessFr(List processParsed)  async {
      
        final List<Map<String, dynamic>> responseProcess =await supabase.from("Processus").select("nom_processus, nom_processus_en");
         Set<String> result = {};

         for (var element in responseProcess) {
                if (element.containsKey("nom_processus_en") && element["nom_processus_en"] != null) {
                  if(processParsed.contains(element["nom_processus_en"])){
                       result.add(element["nom_processus"]);
                  }
                   
                }
            }
            return result.toList();
      }

    Future<List> getTranslateProcessEn(List processParsed) async {
     
            final List<Map<String, dynamic>> responseProcess =await supabase.from("Processus").select("nom_processus, nom_processus_en");
            Set<String> result = {};
              
                for (var element in responseProcess) {
                
                      if (element.containsKey("nom_processus_en") && element["nom_processus_en"] != null) {
                        if(processParsed.contains(element["nom_processus"])){
                                result.add(element["nom_processus_en"]);
                         }
                      }
                }
             
        return result.toList();
        
    }
}