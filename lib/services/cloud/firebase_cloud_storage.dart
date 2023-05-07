import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:metapp/services/chat/chat_exceptions.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/cloud_order_item.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';
import 'package:metapp/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final FirebaseStorage storage = FirebaseStorage.instance;
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

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateChatUserName({
    required String id,
    required String nickname,
  }) async {
    try {
      await users.doc(id).update(
        {
          FirestoreConstants.nickname: nickname,
        },
      );
    } catch (e) {
      throw CouldNotUpdateChatUserNickName();
    }
  }

  Future<void> updateChatUserAboutMe({
    required String id,
    required String aboutMe,
  }) async {
    try {
      await users.doc(id).update(
        {
          FirestoreConstants.aboutMe: aboutMe,
        },
      );
    } catch (e) {
      throw CouldNotUpdateChatUserAboutMe();
    }
  }

  Future<void> updateChatUserProfileUrl({
    required String id,
    required String profileUrl,
  }) async {
    try {
      await users.doc(id).update(
        {
          FirestoreConstants.profileUrl: profileUrl,
        },
      );
    } catch (e) {
      throw CouldNotUpdateChatUserProfileUrl();
    }
  }

  Future<CloudOrder> createNewOrder() async {
    final document = await orders.add(
      {
        FirestoreConstants.orderNumberFieldName: '',
        FirestoreConstants.orderCustomerNumberFieldName: '',
        FirestoreConstants.orderDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).toString(),
      },
    );
    final fetchedOrder = await document.get();
    return CloudOrder(
      documentId: fetchedOrder.id,
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).toString(),
      orderId: '',
      customerId: '',
      items: const Stream.empty(),
    );
  }

  Future<void> deleteOrder({required String documentId}) async {
    try {
      await orders.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteOrderException();
    }
  }

  Future<void> updateOrderCustomerName({
    required String documentId,
    required String customerName,
  }) async {
    try {
      await orders.doc(documentId).update(
        {
          FirestoreConstants.orderCustomerNumberFieldName: customerName,
        },
      );
    } catch (e) {
      throw CouldNotUpdateOrderCustomerNameException();
    }
  }

  Future<void> updateOrderName({
    required String documentId,
    required String orderName,
  }) async {
    try {
      await orders.doc(documentId).update(
        {
          FirestoreConstants.orderNumberFieldName: orderName,
        },
      );
    } catch (e) {
      throw CouldNotUpdateOrderNameException();
    }
  }

  Future<void> updateOrder({
    required String documentId,
    required String customerName,
    required String orderId,
  }) async {
    try {
      await orders.doc(documentId).update(
        {
          FirestoreConstants.orderCustomerNumberFieldName: customerName,
          FirestoreConstants.orderNumberFieldName: orderId,
        },
      );
    } catch (e) {
      throw CouldNotUpdateOrderException();
    }
  }

  Future<ChatUser> createNewUser({
    required String userId,
  }) async {
    await users.doc(userId).set(
      {
        FirestoreConstants.aboutMe: '',
        FirestoreConstants.nickname: '',
        FirestoreConstants.profileUrl: '',
        FirestoreConstants.userId: userId,
      },
    );
    return ChatUser(
      id: userId,
      aboutMe: '',
      profileImageUrl: '',
      nickname: '',
    );
  }

  Stream<ChatUser> getCurrentChatUser({
    required String id,
  }) {
    return users.doc(id).snapshots().map(
          (document) => ChatUser.fromDocument(document),
        );
  }

  Future<CloudOrderItem> createNewOrderItem({
    required String orderId,
  }) async {
    final document = await orders
        .doc(orderId)
        .collection(FirestoreConstants.orderItemsCollectionFieldName)
        .add(
      {
        FirestoreConstants.orderItemsItemNameFieldName: '',
        FirestoreConstants.orderItemsItemQuantityFieldName: '',
        FirestoreConstants.orderItemsPackagingFieldName: '',
      },
    );

    final fetchedItem = await document.get();
    return CloudOrderItem(
      id: fetchedItem.id,
      itemName: '',
      packaging: '',
      quantity: '',
    );
  }

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

  Future<void> deleteOrderItem({
    required String orderId,
    required String documentId,
  }) async {
    try {
      await orders
          .doc(orderId)
          .collection(FirestoreConstants.orderItemsCollectionFieldName)
          .doc(documentId)
          .delete();
    } catch (e) {
      throw CouldNotDeleteOrderItemException();
    }
  }

  Future<void> updateOrderItemName({
    required String orderId,
    required String documentId,
    required String orderItemName,
  }) async {
    try {
      await orders
          .doc(orderId)
          .collection(FirestoreConstants.orderItemsCollectionFieldName)
          .doc(documentId)
          .update(
        {
          FirestoreConstants.orderItemsItemNameFieldName: orderItemName,
        },
      );
    } catch (e) {
      throw CouldNotUpdateOrderItemNameException();
    }
  }

  Future<void> updateOrderItemQuantity({
    required String orderId,
    required String documentId,
    required String orderItemQuantity,
  }) async {
    try {
      await orders
          .doc(orderId)
          .collection(FirestoreConstants.orderItemsCollectionFieldName)
          .doc(documentId)
          .update(
        {
          FirestoreConstants.orderItemsItemQuantityFieldName: orderItemQuantity,
        },
      );
    } catch (e) {
      throw CouldNotUpdateOrderItemQuantityException();
    }
  }

  Future<void> updateOrderItemPackaging({
    required String orderId,
    required String documentId,
    required String orderItemPackaging,
  }) async {
    try {
      await orders
          .doc(orderId)
          .collection(FirestoreConstants.orderItemsCollectionFieldName)
          .doc(documentId)
          .update(
        {
          FirestoreConstants.orderItemsPackagingFieldName: orderItemPackaging,
        },
      );
    } catch (e) {
      throw CouldNotUpdateOrderItemPackagingException();
    }
  }

  Future<void> updateOrderItem({
    required String orderId,
    required String documentId,
    required String orderItemName,
    required String orderItemQuantity,
    required String orderItemPackaging,
  }) async {
    try {
      await orders
          .doc(orderId)
          .collection(FirestoreConstants.orderItemsCollectionFieldName)
          .doc(documentId)
          .update(
        {
          FirestoreConstants.orderItemsItemNameFieldName: orderItemName,
          FirestoreConstants.orderItemsItemQuantityFieldName: orderItemQuantity,
          FirestoreConstants.orderItemsPackagingFieldName: orderItemPackaging,
        },
      );
    } catch (e) {
      throw CouldNotUpdateOrderItemException();
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

  Stream<Iterable<CloudOrder>> allOrders(
    int limit,
  ) {
    final orderItems = orders
        .doc()
        .collection(FirestoreConstants.orderItemsCollectionFieldName)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudOrderItem.fromSnapshot(doc),
          ),
        );
    return orders.snapshots().map(
          (event) => event.docs.map(
            (doc) => CloudOrder.fromSnapshot(
              doc,
              orderItems,
            ),
          ),
        );
  }

  Stream<Iterable<CloudOrderItem>> allOrderItems({
    required String orderId,
  }) {
    return orders
        .doc(orderId)
        .collection(FirestoreConstants.orderItemsCollectionFieldName)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudOrderItem.fromSnapshot(doc),
          ),
        );
  }

  Future<void> addCurrentAuthUserToChatUsers({
    required String userId,
  }) async {
    final users = allUsers();
    int userIdInUsers = 0;
    try {
      await users.forEach(
        (element) {
          element.toList().forEach(
            (element) {
              if (element.id == userId) {
                userIdInUsers++;
              }
            },
          );
          if (userIdInUsers == 0) {
            createNewUser(
              userId: userId,
            );
          }
        },
      );
    } catch (e) {
      throw CouldNotCompleteUserCheckChatException();
    }
  }
}
