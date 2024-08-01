import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

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

  Future downloadExcel(Map<String, dynamic> mapData) async {
    final entite = mapData["entite"];
    final annee = mapData["annee"];
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];

    final List<String> headers = [
      'numero',
      'Reference',
      'Indicateurs',
      'Unite',
      'Realise_$annee'
    ];
    for (int col = 1; col <= headers.length; col++) {
      sheet.getRangeByIndex(1, col).setText(headers[col - 1]);
    }
    sheet
        .getRangeByIndex(1, 1)
        .columnWidth = 10;
    sheet
        .getRangeByIndex(1, 2)
        .columnWidth = 15;
    sheet
        .getRangeByIndex(1, 3)
        .columnWidth = 100;
    sheet
        .getRangeByIndex(1, 4)
        .columnWidth = 15;
    sheet
        .getRangeByIndex(1, 5)
        .columnWidth = 15;

    final List<dynamic> listData = mapData["data"];
    for (var row = 0; row < listData.length; row++) {
      final item = listData[row];
      if (item["numero"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 1).setText(item["numero"].toString());
      }
      if (item["reference"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 2).setText(item["reference"].toString());
      }
      if (item["intitule"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 3).setText(item["intitule"].toString());
      }
      if (item["unite"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 4).setText(item["unite"].toString());
      }
      if (item["realise"] == null) {
        continue;
      } else {
        sheet.getRangeByIndex(row + 2, 5).setText(item["realise"].toString());
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
    List sousEntites = entitePilotageController.sousEntite;
    List sousEntitesNames = entitePilotageController.sousEntiteName;

    List<String> initialRow = [
      "Référence",
      'Indicateurs',
      'Unité',
      'Réalisé $annee',
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
      for (String sousEntiteName in sousEntitesNames) {
        initialRow.add("$sousEntiteName\n Realise $annee");
      }
    }
    final List<List<String>> result = [initialRow];

    for (var data in datas) {
      var a = "${data["intitule"]}".replaceAll('’', "'");
      var intutle = a.replaceAll("…", "...");
      result.add([
        "${data["reference"]}",
        intutle,
        "${data["unite"]}",
        "${data["realise"] ?? "---"}",
        "${data["dataJan"] ?? "---"}",
        "${data["dataFeb"] ?? "---"}",
        "${data["dataMar"] ?? "---"}",
        "${data["dataApr"] ?? "---"}",
        "${data["dataMay"] ?? "---"}",
        "${data["dataJun"] ?? "---"}",
        "${data["dataJul"] ?? "---"}",
        "${data["dataAug"] ?? "---"}",
        "${data["dataSep"] ?? "---"}",
        "${data["dataOct"] ?? "---"}",
        "${data["dataNov"] ?? "---"}",
        "${data["dataDec"] ?? "---"}",
        "${data["###"]}"
      ]);

      List<String> lastElement = result[result.length - 1];

      if (sousEntites.isNotEmpty) {
        for (int i = 0; i < sousEntites.length; i++) {
          lastElement.add("${data["sousEntite$i"] ?? "---"}");
        }
        result[result.length - 1] = lastElement;
      }
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
    try {
      final logoSFICA = await rootBundle.load(
          'assets/logos/logo_sifca_bon.png');
      final Uint8List bytesLogoSFICA = logoSFICA.buffer.asUint8List();
      final Uint8List? bytesLogoFiliale = entitePilotageController.bytesLogo;

      final List<dynamic> allData = mapData["data"];

      // Load the fonts
      final fontRegular =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
      final fontBold =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));

      // Create a PDF document
      final pdf = pw.Document();

      const columnsPerPage = 16; // Adjust this number based on your needs

      // Generate the header
      final header = [
        "Référence",
        'Indicateurs',
        'Unité',
        'Réalisé ${mapData["annee"]}',
        'Janvier ${mapData["annee"]}',
        'Fevrier ${mapData["annee"]}',
        'Mars ${mapData["annee"]}',
        'Avril ${mapData["annee"]}',
        'Mai ${mapData["annee"]}',
        'Juin ${mapData["annee"]}',
        'Juillet ${mapData["annee"]}',
        'Aout ${mapData["annee"]}',
        'Septembre ${mapData["annee"]}',
        'Octobre ${mapData["annee"]}',
        'Novembre ${mapData["annee"]}',
        'Decembre ${mapData["annee"]}',
      ];

      final rows = getRows(allData, mapData["annee"]);

      // Split columns into multiple pages if necessary
      for (var i = 0; i < header.length; i += columnsPerPage) {
        final chunkHeader = header.sublist(
          i,
          i + columnsPerPage > header.length ? header.length : i +
              columnsPerPage,
        );

        final chunkRows = rows.map((row) {
          return row.sublist(
            i,
            i + columnsPerPage > row.length ? row.length : i + columnsPerPage,
          );
        }).toList();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4.landscape,
            // margin: const pw.EdgeInsets.only(
            //     left: 10, right: 10, top: 20, bottom: 20),
            build: (pw.Context context) =>
            [
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
                            width: 80,
                            height: 40,
                          ),
                          pw.Text('Indicateurs de Performance RSE',
                              style: pw.TextStyle(
                                  font: fontBold,
                                  color: getColor(mapData["color"]),
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          bytesLogoFiliale != null
                              ? pw.Image(
                            pw.MemoryImage(
                              bytesLogoFiliale,
                            ),
                            width: 80,
                            height: 40,
                          )
                              : pw.Container(),
                        ])),
              ),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text(
                    "Entreprise : ", style: pw.TextStyle(font: fontRegular)),
                pw.Text("${mapData["entreprise"]}",
                    style: pw.TextStyle(
                        font: fontBold, fontWeight: pw.FontWeight.bold))
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text("Filiale : ", style: pw.TextStyle(font: fontRegular)),
                pw.Text("${mapData["filiale"]}",
                    style: pw.TextStyle(
                        font: fontBold, fontWeight: pw.FontWeight.bold))
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text("Entité : ", style: pw.TextStyle(font: fontRegular)),
                pw.Text("${mapData["entite"]}",
                    style: pw.TextStyle(
                        font: fontBold, fontWeight: pw.FontWeight.bold))
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text("Année : ", style: pw.TextStyle(font: fontRegular)),
                pw.Text("${mapData["annee"]}",
                    style: pw.TextStyle(
                        font: fontBold, fontWeight: pw.FontWeight.bold))
              ]),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  font: fontBold,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: pw.TextStyle(font: fontRegular, fontSize: 10),
                oddRowDecoration:
                const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE5E5E5)),
                headerDecoration:
                pw.BoxDecoration(color: getColor(mapData["color"])),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey, width: .5)),
                ),
                headers: chunkHeader,
                data: chunkRows,
              ),
            ],
          ),
        );
      }

      // Save the PDF as a Uint8List
      return await pdf.save();
    } catch (e) {
      print("Error generating PDF: $e");
      rethrow;
    }
  }
}
