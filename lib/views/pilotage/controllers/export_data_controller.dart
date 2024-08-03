import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'dart:convert';

import '../../../api/supabse_db.dart';
import 'entite_pilotage_controler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportDataController {
  final DataBaseController dataBaseController = DataBaseController();
  final EntitePilotageController entitePilotageController = Get.find();

  Future<Map<String, dynamic>?> loadDataExport(String entite, int annee) async {
    final result = await dataBaseController.getExportEntite(entite, annee);
    return result;
  }

  Future<void> downloadExcel(Map<String, dynamic> mapData) async {
    try {
      List sousEntites = entitePilotageController.sousEntite;
      List sousEntitesNames = entitePilotageController.sousEntiteName;

      final logoSFICA =
          await rootBundle.load('assets/logos/logo_sifca_bon.png');
      final Uint8List bytesLogoSFICA = logoSFICA.buffer.asUint8List();
      final Uint8List? bytesLogoFiliale = entitePilotageController.bytesLogo;

      // Convert Uint8List to Base64 string
      final String base64LogoSFICA = base64Encode(bytesLogoSFICA);
      final String? base64LogoFiliale =
          bytesLogoFiliale != null ? base64Encode(bytesLogoFiliale) : null;

      final entite = mapData["entite"];
      final annee = mapData["annee"];
      final xcel.Workbook workbook = xcel.Workbook();
      final xcel.Worksheet sheet = workbook.worksheets[0];

      // Adding the logos and details
      sheet.getRangeByIndex(1, 1).setText('Indicateurs de Performance RSE');
      final xcel.Style headerStyle = workbook.styles.add('headerStyle');
      headerStyle.fontName = 'Arial';
      headerStyle.fontSize = 20;
      headerStyle.bold = true;
      sheet.getRangeByIndex(1, 1).cellStyle = headerStyle;

      // Merging cells for the title
      sheet.getRangeByIndex(1, 1, 1, 5).merge();

      // Adding logo SFICA
      final xcel.Picture picture1 =
          sheet.pictures.addBase64(2, 1, base64LogoSFICA);
      picture1.height = 40;
      picture1.width = 80;

      // Adding logo Filiale if it exists
      if (bytesLogoFiliale != null) {
        final xcel.Picture picture2 =
            sheet.pictures.addBase64(2, 5, base64LogoFiliale!);
        picture2.height = 40;
        picture2.width = 80;
      }

      // Adding details
      final details = [
        ['Entreprise :', mapData["entreprise"]],
        ['Filiale :', mapData["filiale"]],
        ['Entité :', mapData["entite"]],
        ['Année :', "${mapData["annee"]}"]
      ];

      int startRow = 3;
      for (var detail in details) {
        sheet.getRangeByIndex(startRow, 1).setText(detail[0]);
        sheet.getRangeByIndex(startRow, 2).setText(detail[1]);
        sheet.getRangeByIndex(startRow, 2).cellStyle.bold = true;
        startRow++;
      }

      // Set header row
      final List<String> initialHeaders = [
        'Reference',
        'Indicateurs',
        'Unite',
        'Realisé_$annee',
        'Janvier $annee',
        'Fevrier $annee',
        'Mars $annee',
        'Avril $annee',
        'Mai $annee',
        'Juin $annee',
        'Juillet $annee',
        'Aout $annee',
        'Septembre $annee',
        'Octobre $annee',
        'Novembre $annee',
        'Decembre $annee',
      ];

      if (sousEntites.isNotEmpty) {
        initialHeaders.add("###");
        for (String sousEntiteName in sousEntitesNames) {
          initialHeaders.add("$sousEntiteName\n Realise $annee");
        }
      }
      final List<String> finalHeaders = initialHeaders;

      for (int col = 1; col <= finalHeaders.length; col++) {
        sheet.getRangeByIndex(startRow, col).setText(finalHeaders[col - 1]);
        sheet.getRangeByIndex(startRow, col).cellStyle.bold = true;
        sheet.getRangeByIndex(startRow, col).cellStyle.backColor =
            '#4F81BD'; // example color
        //sheet.getRangeByIndex(startRow, col).cellStyle.fontColor = '#FFFFFF';
      }

      // Set column widths
      sheet.getRangeByIndex(startRow, 1).columnWidth = 15;
      sheet.getRangeByIndex(startRow, 2).columnWidth = 100;
      sheet.getRangeByIndex(startRow, 3).columnWidth = 15;
      sheet.getRangeByIndex(startRow, 4).columnWidth = 15;
      for (int col = 5; col <= 16; col++) {
        sheet.getRangeByIndex(startRow, col).columnWidth = 15;
      }

      //Define styles based on indicator type
      final xcel.Style testIndicatorStyle =
          workbook.styles.add('testIndicatorStyle');
      testIndicatorStyle.backColor = '#AEAEAE';
      final xcel.Style calculatedIndicatorStyle =
          workbook.styles.add('calculatedIndicatorStyle');
      calculatedIndicatorStyle.backColor = '#00ff00';
      final xcel.Style defaultIndicatorStyle =
          workbook.styles.add('defaultIndicatorStyle');
      defaultIndicatorStyle.backColor = '#FFFFFF';

      if (sousEntites.isNotEmpty) {
        sheet.getRangeByIndex(startRow, 17).columnWidth = 5;
        for (int col = 18; col <= finalHeaders.length; col++) {
          sheet.getRangeByIndex(startRow, col).columnWidth = 23;
        }
      }

      // Add data
      final List<dynamic> listData = mapData["data"];
      for (var row = 0; row < listData.length; row++) {
        final item = listData[row];
        xcel.Style cellStyle;

        // Determine the style based on the indicator type
        if (item["type"] == "Calculé") {
          cellStyle = calculatedIndicatorStyle;
        } else if (item["type"] == "Test") {
          cellStyle = testIndicatorStyle;
        } else {
          cellStyle = defaultIndicatorStyle;
        }

        if (item["reference"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 1)
              .setText(item["reference"].toString());
          sheet.getRangeByIndex(row + startRow + 1, 1).cellStyle = cellStyle;
        }
        if (item["intitule"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 2)
              .setText(item["intitule"].toString());
          sheet.getRangeByIndex(row + startRow + 1, 2).cellStyle = cellStyle;
        }
        if (item["unite"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 3)
              .setText(item["unite"].toString());
          sheet.getRangeByIndex(row + startRow + 1, 3).cellStyle = cellStyle;
        }
        if (item["realise"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 4)
              .setText(formatValue(item["realise"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 4).cellStyle = cellStyle;
        }
        if (item["dataJan"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 5)
              .setText(formatValue(item["dataJan"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 5).cellStyle = cellStyle;
        }
        if (item["dataFeb"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 6)
              .setText(formatValue(item["dataFeb"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 6).cellStyle = cellStyle;
        }
        if (item["dataMar"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 7)
              .setText(formatValue(item["dataMar"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 7).cellStyle = cellStyle;
        }
        if (item["dataApr"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 8)
              .setText(formatValue(item["dataApr"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 8).cellStyle = cellStyle;
        }
        if (item["dataMay"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 9)
              .setText(formatValue(item["dataMay"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 9).cellStyle = cellStyle;
        }
        if (item["dataJun"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 10)
              .setText(formatValue(item["dataJun"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 10).cellStyle = cellStyle;
        }
        if (item["dataJul"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 11)
              .setText(formatValue(item["dataJul"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 11).cellStyle = cellStyle;
        }
        if (item["dataAug"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 12)
              .setText(formatValue(item["dataAug"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 12).cellStyle = cellStyle;
        }
        if (item["dataSep"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 13)
              .setText(formatValue(item["dataSep"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 13).cellStyle = cellStyle;
        }
        if (item["dataOct"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 14)
              .setText(formatValue(item["dataOct"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 14).cellStyle = cellStyle;
        }
        if (item["dataNov"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 15)
              .setText(formatValue(item["dataNov"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 15).cellStyle = cellStyle;
        }
        if (item["dataDec"] != null) {
          sheet
              .getRangeByIndex(row + startRow + 1, 16)
              .setText(formatValue(item["dataDec"], item["type"], item["unite"]));
          sheet.getRangeByIndex(row + startRow + 1, 16).cellStyle = cellStyle;
        }

        if (sousEntites.isNotEmpty) {
          int j = 17;
          if (item["###"] != null) {
            sheet
                .getRangeByIndex(row + startRow + 1, 17)
                .setText(item["###"].toString());
          }
          for (int i = 0; i < sousEntites.length; i++) {
            if (item["sousEntite$i"] != null) {
              sheet
                  .getRangeByIndex(row + startRow + 1, j++)
                  .setText(formatValue(item["sousEntite$i"], item["type"], item["unite"]));
              sheet.getRangeByIndex(row + startRow + 1, j).cellStyle =
                  cellStyle;
            }
          }
        }
      }

      final List<int> bytes = workbook.saveAsStream();
      final Uint8List excelBytes = Uint8List.fromList(bytes);
      final String fileName = '${entite}_$annee.xlsx';

      if (kIsWeb) {
        final html.Blob blob = html.Blob([excelBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();

        html.Url.revokeObjectUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }

  String? formatValue(double value, String? type, String unite) {
    if (type == "Test") {
      if (value == 1) {
        return "Vrai";
      } else {
        return "Faux";
      }
    } else if (unite == "%" || unite == "Ratio") {
      return (value * 100).toStringAsFixed(3);
    } else {
      return value.toString();
    }
  }

  Future downloadPDF(Map<String, dynamic> mapData) async {
    // Générer le PDF
    final Uint8List pdfBytes = await generatePDF(mapData);

    // Convertir les bytes du PDF en un objet blob
    final blob = html.Blob([pdfBytes]);

    final entite = mapData["entite"] ?? "";
    final annne = mapData["annee"] ?? "";

    final version = Random().nextInt(100);

    // Créer un objet URL pour le blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Créer un élément <a> pour télécharger le fichier PDF
    html.AnchorElement(href: url)
      ..setAttribute(
          "download", "indicateurs_performance_${entite}_${annne}_$version.pdf")
      ..click(); // Simuler le clic sur le lien pour démarrer le téléchargement

    // Libérer l'URL de l'objet blob après le téléchargement
    html.Url.revokeObjectUrl(url);
  }

  List<List<String>> getRows(List<dynamic> datas, dynamic annee) {
    List<String> initialRow = [
      '#',
      "Référence",
      'Indicateurs',
      'Unité',
      'Réalisé $annee'
    ];
    final List<List<String>> result = [initialRow];

    for (var data in datas) {
      var a = "${data["intitule"]}".replaceAll('’', "'");
      var intutle = a.replaceAll("…", "...");
      result.add([
        "${data["numero"]}",
        "${data["reference"]}",
        intutle,
        "${data["unite"]}",
        "${data["realise"] ?? "---"}",
      ]);
    }

    return result;
  }

  PdfColor getColor(String kColor) {
    final Map<String, PdfColor> mapColor = {
      "bleu-ciel": PdfColors.blue,
      "gris": PdfColors.amber,
      "vert": PdfColors.green,
      "rouge": PdfColors.red,
    };
    final color = mapColor[kColor] ?? PdfColors.amber;
    return color;
  }

  Future<Uint8List> generatePDF(Map<String, dynamic> mapData) async {
    final logoSFICA = await rootBundle.load('assets/logos/logo_sifca_bon.png');
    final Uint8List bytesLogoSFICA = logoSFICA.buffer.asUint8List();
    final Uint8List? bytesLogoFiliale = entitePilotageController.bytesLogo;

    final List<dynamic> allData = mapData["data"];

    // Create a PDF document
    final pdf = pw.Document();

    // Add the table to the PDF
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.only(
            left: 10, right: 10, top: 20, bottom: 20), // Ajuster les marges ici
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Container(
                  height: 50,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(
                          pw.MemoryImage(
                            bytesLogoSFICA,
                          ),
                          width: 80, // Adjust width as needed
                          height: 40, // Adjust height as needed
                        ),
                        pw.Text('Indicateurs de Performance RSE',
                            style: pw.TextStyle(
                                color: getColor(mapData["color"]),
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold)),
                        bytesLogoFiliale != null
                            ? pw.Image(
                                pw.MemoryImage(
                                  bytesLogoFiliale,
                                ),
                                width: 80, // Adjust width as needed
                                height: 40, // Adjust height as needed
                              )
                            : pw.Container(),
                      ])),
            ),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Entreprise : "),
              pw.Text("${mapData["entreprise"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Filiale : "),
              pw.Text("${mapData["filiale"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Entité : "),
              pw.Text("${mapData["entite"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Text("Année : "),
              pw.Text("${mapData["annee"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FixedColumnWidth(100),
                3: const pw.FixedColumnWidth(85),
                4: const pw.FixedColumnWidth(140),
              },
              context: context,
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              oddRowDecoration:
                  const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE5E5E5)),
              headerDecoration:
                  pw.BoxDecoration(color: getColor(mapData["color"])),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey, width: .5)),
              ),
              data: getRows(allData, mapData["annee"]),
            ),
          ];
        },
      ),
    );

    // Save the PDF as a Uint8List
    return await pdf.save();
  }
}
