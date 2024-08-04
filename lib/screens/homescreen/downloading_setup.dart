import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;

Future<List<Map<String, dynamic>>> fetchFirestoreData(String collection) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(collection).get();
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

// Future<void> generateExcel(List<Map<String, dynamic>> data) async {
//   var excel = Excel.createExcel();
//   Sheet sheetObject = excel['Sheet1'];

//   // Add header
//   if (data.isNotEmpty) {
//     sheetObject.appendRow(data.first.keys
//         .map((key) => key.toString())
//         .cast<CellValue?>()
//         .toList());
//   }

//   // Add data
//   for (var row in data) {
//     sheetObject.appendRow(row.values
//         .map((value) => value.toString())
//         .cast<CellValue?>()
//         .toList());
//   }

//   // Save file
//   var directory = await getApplicationDocumentsDirectory();
//   var file = File('${directory.path}/firestore_data.xlsx')
//     ..createSync(recursive: true)
//     ..writeAsBytesSync(List<int>.from(excel.encode()!));

//   // Share file
//   await Share.shareXFiles([XFile(file.path)], text: 'Firestore Data');
// }

Future<void> generatePdf(List<Map<String, dynamic>> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Add header
            if (data.isNotEmpty)
              pw.Text(
                'Vacancy Data',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            pw.SizedBox(height: 20),

            // Add data
            ...data.map((row) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: row.entries.map((entry) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8.0),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '${entry.key}: ',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Expanded(
                          child: pw.Text(entry.value.toString()),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                
              );
            }),
          ],
        );
      },
    ),
  );

  // Save file
  var directory = await getApplicationDocumentsDirectory();
  var file = File('${directory.path}/firestore_data.pdf')
    ..createSync(recursive: true)
    ..writeAsBytesSync(await pdf.save());

  // Share file
  await Share.shareXFiles([XFile(file.path)], text: 'Firestore Data');
}
