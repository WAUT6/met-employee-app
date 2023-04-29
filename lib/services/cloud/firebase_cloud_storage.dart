import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';
import 'package:metapp/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final items = FirebaseFirestore.instance
      .collection(FirestoreConstants.itemsCollectionPathName);
  final orders = FirebaseFirestore.instance
      .collection(FirestoreConstants.ordersCollectionPathName);
  final users = FirebaseFirestore.instance
      .collection(FirestoreConstants.usersCollectionPathName);
  final messages = FirebaseFirestore.instance
      .collection(FirestoreConstants.messagesCollectionPathName);

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudOrder> createNewOrder() async {
    final document = await orders.add(
      {
        FirestoreConstants.orderNumberFieldName: '',
        FirestoreConstants.orderCustomerNumberFieldName: '',
        'order_items': {},
      },
    );
    final fetchedOrder = await document.get();
    return CloudOrder(
      documentId: fetchedOrder.id,
      orderId: '',
      customerId: '',
      items: [],
    );
  }

  Future<void> deleteOrder({required String documentId}) async {
    try {
      await orders.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteOrderException();
    }
  }

  // Future<void> updateOrder()

  Future<CloudItem> createNewItem() async {
    final document = await items.add(
      {
        FirestoreConstants.itemNameFieldName: '',
        FirestoreConstants.itemPriceFieldName: '',
      },
    );

    final fetchedItem = await document.get();
    return CloudItem(
      documentId: fetchedItem.id,
      name: '',
      price: '',
    );
  }

  Future<void> deleteItem({required String documentId}) async {
    try {
      await items.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteItemException();
    }
  }

  Future<void> updateItemName({
    required String documentId,
    required String itemName,
  }) async {
    try {
      await items.doc(documentId).update(
        {
          FirestoreConstants.itemNameFieldName: itemName,
        },
      );
    } catch (e) {
      throw CouldNotUpdateItemNameException();
    }
  }

  Future<void> updateItemPrice({
    required String documentId,
    required String itemPrice,
  }) async {
    try {
      await items.doc(documentId).update(
        {
          FirestoreConstants.itemPriceFieldName: itemPrice,
        },
      );
    } catch (e) {
      throw CouldNotUpdateItemPriceException();
    }
  }

  Future<void> updateItem({
    required String documentId,
    required String itemName,
    required String itemPrice,
  }) async {
    try {
      await items.doc(documentId).update(
        {
          FirestoreConstants.itemNameFieldName: itemName,
          FirestoreConstants.itemPriceFieldName: itemPrice,
        },
      );
    } catch (e) {
      throw CouldNotUpdateItemException();
    }
  }

  Stream<Iterable<ChatMessage>> allMessages(
    int limit,
    String groupChatId,
  ) =>
      messages
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy(
            FirestoreConstants.time,
            descending: true,
          )
          .snapshots()
          .map(
            (event) => event.docs.map(
              (doc) => ChatMessage.fromDocument(doc),
            ),
          );

  Stream<Iterable<CloudItem>> allItems() => items.snapshots().map(
        (event) => event.docs.map(
          (doc) => CloudItem.fromSnapshot(doc),
        ),
      );

  Stream<Iterable<ChatUser>> allUsers() => users.snapshots().map(
        (event) => event.docs.map(
          (doc) => ChatUser.fromSnapshot(doc),
        ),
      );
}
