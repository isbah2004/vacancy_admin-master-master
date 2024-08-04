import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vacancy_admin/theme/theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> fireStoreStream =
        FirebaseFirestore.instance.collection('vacancies').snapshots();

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.blueColor,
        title: Text(
          'Vacancy Summary',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppTheme.whiteColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              double fontSize = constraints.maxWidth < 600 ? 13 : 15;
              double headingFontSize = constraints.maxWidth < 600 ? 13 : 15;
              double columnSpacing = constraints.maxWidth < 600 ? 10 : 20;

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: DataTable(
                            border: TableBorder.all(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            columnSpacing: columnSpacing,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) => AppTheme.blueColor),
                            headingTextStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppTheme.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: headingFontSize,
                                    ),
                            dataTextStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: fontSize,
                                ),
                            columns: const [
                              DataColumn(
                                  label: FittedBox(child: Text('Department'))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          FittedBox(child: Text('Vacancy')))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          FittedBox(child: Text('Approved')))),
                              DataColumn(
                                  label: Expanded(
                                      child:
                                          FittedBox(child: Text('Manpower')))),
                              DataColumn(
                                  label: Expanded(
                                      child: FittedBox(child: Text('Number')))),
                            ],
                            rows: data.map((doc) {
                              return DataRow(
                                cells: [
                                  DataCell(FittedBox(
                                      child:
                                          Text(doc['department'].toString()))),
                                  DataCell(FittedBox(
                                      child: Text(doc['vacancy'].toString()))),
                                  DataCell(FittedBox(
                                      child: Text(
                                          doc['approved_numbers'].toString()))),
                                  DataCell(FittedBox(
                                      child: Text(
                                          doc['manpower_numbers'].toString()))),
                                  DataCell(FittedBox(
                                      child: Text(doc['number'].toString()))),
                                ],
                              );
                            }).toList(),
                            dividerThickness: 1,
                            horizontalMargin: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
