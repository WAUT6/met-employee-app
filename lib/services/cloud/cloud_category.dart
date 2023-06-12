import 'package:cloud_firestore/cloud_firestore.dart';

import 'cloud_item.dart';

class CloudCategory {
  final Stream<Iterable<CloudItem>> items;
  final String categoryName;


  CloudCategory({required this.items, required this.categoryName,});

  CloudCategory.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot, this.items,) :
  categoryName = snapshot.id;


}