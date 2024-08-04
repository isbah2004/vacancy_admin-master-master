import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vacancy_admin/provider/upload_provider.dart';
import 'package:vacancy_admin/reusablewidgets/neomorphism_widget.dart';
import 'package:vacancy_admin/screens/detailscreen/detail_screen.dart';
import 'package:vacancy_admin/screens/postscreens/add_files.dart';
import 'package:vacancy_admin/screens/postscreens/update_file.dart';
import 'package:vacancy_admin/theme/theme.dart';
import 'package:vacancy_admin/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fireStore =
      FirebaseFirestore.instance.collection('vacancies').snapshots();

  CollectionReference urlRef =
      FirebaseFirestore.instance.collection('vacancies');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        // actions: [
        //   GestureDetector(
        //     onTap: () async {
        //       var data = await fetchFirestoreData('vacancies');
        //       await generatePdf(data);
        //     },
        //     child: const Icon(Icons.download),
        //   )
        // ],

        centerTitle: true,
        title: Text(
          'Current Manpower Status and Vacancy Overview',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppTheme.whiteColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.6),
                    child: Center(
                      child: Text(
                        'Something went wrong',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.6),
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.6),
                  child: Center(
                    child: Text(
                      'No data available',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 8),
                      child: NeomorphicWidget(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                    department: data['department'],
                                    approvedNumbers: data['approved_numbers'],
                                    manpowerNumbers: data['manpower_numbers'],
                                    vacancy: data['vacancy'],
                                    detail: data['details'],
                                    number: data['number']),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppTheme.greyColor),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Image(
                                        image: AssetImage(
                                            Constants.jobSearchImage),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(data['department'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            )),
                                  ],
                                ),
                                Consumer<UploadProvider>(
                                  builder: (BuildContext context,
                                      UploadProvider value, Widget? child) {
                                    return PopupMenuButton(
                                      color: AppTheme.greyColor,
                                      elevation: 4,
                                      padding: EdgeInsets.zero,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      icon: const Icon(
                                        Icons.more_vert,
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateFile(
                                                          docId: document.id,
                                                          existingData: data),
                                                ),
                                              );
                                            },
                                            leading: const Icon(Icons.edit),
                                            title: const Text('Edit'),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: ListTile(
                                            onTap: () {
                                              value.deleteFile(
                                                  docId: document.id,
                                                  context: context);
                                            },
                                            leading: const Icon(
                                                Icons.delete_outline),
                                            title: const Text('Delete'),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFile(),
              ),
            );
          }),
    );
  }
}
