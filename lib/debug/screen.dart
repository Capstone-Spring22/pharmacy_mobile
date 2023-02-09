import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebugScreen extends GetView<MyController> {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Center(
        child: Text(controller.list.toString()),
      ),
    );
  }
}

class MyController extends GetxController {
  final Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('mock-data').snapshots();

  final list = <DocumentSnapshot>[].obs;

  void addData() {
    stream.listen((snapshot) {
      list.value = snapshot.docs;
    });
  }
}
