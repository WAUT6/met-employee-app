import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:metapp/services/chat/chat_exceptions.dart';
import 'package:metapp/services/chat/chat_message.dart';
import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/services/cloud/cloud_category.dart';
import 'package:metapp/services/cloud/cloud_item.dart';
import 'package:metapp/services/cloud/cloud_order.dart';
import 'package:metapp/services/cloud/cloud_order_item.dart';
import 'package:metapp/services/cloud/cloud_storage_constants.dart';
import 'package:metapp/services/cloud/cloud_storage_exceptions.dart';

import 'cloud_category_item.dart';

class FirebaseCloudStorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final items = FirebaseFirestore.instance
      .collection(FirestoreConstants.itemsCollectionPathName);
  final orders = FirebaseFirestore.instance
      .collection(FirestoreConstants.ordersCollectionPathName);
  final users = FirebaseFirestore.instance
      .collection(FirestoreConstants.usersCollectionPathName);
  final messages = FirebaseFirestore.instance
      .collection(FirestoreConstants.messagesCollectionPathName);
  final categories = FirebaseFirestore.instance.collection(FirestoreConstants.categoriesCollectionPathName);

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  UploadTask uploadFile(File file, String fileName) {
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(file);
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
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second,
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
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
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

  Future<void> deleteAllOrders() async {
    try {
      final snapshot = await orders.get();
      for (DocumentSnapshot docSnapshot in snapshot.docs) {
        await docSnapshot.reference.delete();
      }
    } catch (e) {
      throw CouldNotDeleteAllOrdersException();
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
    final document = orders
        .doc(orderId)
        .collection(FirestoreConstants.orderItemsCollectionFieldName)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());


    final item = CloudOrderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemName: '',
      packaging: '',
      quantity: '',
      isReady: false,
    );

    await firestore.runTransaction((transaction) async {
      transaction.set(document, item.orderItemToJson());
    });

   return item;

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

  Future<void> updateOrderItemIsReady({required String orderId, required String documentId, required bool isReady,}) async {
    try {
      await orders.doc(orderId).collection(FirestoreConstants.orderItemsCollectionFieldName).doc(documentId).update(
          {
            FirestoreConstants.orderItemsIsReadyFieldName: isReady,
          });
    } catch (e) {
      throw CouldNotUpdateOrderItemIsReadyException();
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

  Future<void> deleteItemFromCategory({required CloudCategory category, required CloudItem item,}) async {
    try {
      await categories.doc(category.categoryName).collection(FirestoreConstants.categoryItemsCollectionPathName).doc(item.documentId).delete();
    } catch (e) {
      throw CouldNotDeleteItemFromCategoryException();
    }
  }

  Future<void> updateCategoryItemName({required CloudCategory category, required CloudItem item, required String name,}) async {
    try {
      await categories.doc(category.categoryName).collection(FirestoreConstants.categoryItemsCollectionPathName).doc(item.documentId).update({
        FirestoreConstants.itemNameFieldName : name,
      });
    } catch (e) {
      throw CouldNotUpdateCategoryItemNameException();
    }
  }

  Future<void> updateCategoryItemPrice({required CloudCategory category, required CloudItem item, required String price,}) async {
    try {
      await categories.doc(category.categoryName).collection(FirestoreConstants.categoryItemsCollectionPathName).doc(item.documentId).update({
        FirestoreConstants.itemPriceFieldName : price,
      });
    } catch (e) {
      throw CouldNotUpdateCategoryItemPriceException();
    }
  }

  Future<void> addItemToCategory({required CloudCategory category, required CloudItem item,}) async {
    try {
      await categories.doc(category.categoryName).collection(FirestoreConstants.categoryItemsCollectionPathName).doc(item.documentId).set(
          {
            FirestoreConstants.itemNameFieldName : item.name,
            FirestoreConstants.itemPriceFieldName : item.price,
            FirestoreConstants.categoryItemReferenceFieldName : '${FirestoreConstants.itemsCollectionPathName}/${item.documentId}/',
          });
    } catch (e) {
      throw CouldNotAddItemToCategoryException();
    }
  }

  // Stream<Iterable<CloudCategory>> allCategories() {
  //   final categoriesItems = categories.snapshots().forEach((category) {
  //     category.docs.map((snapshot) => null)
  //   });
  // }

  Stream<CloudCategory> getCategory({required String categoryName}) {
    return categories.doc(categoryName).snapshots().map((doc) => CloudCategory.fromDocument(doc, const Stream.empty()));
  }

  Stream<Iterable<CloudCategoryItem>> allCategoryItems({required CloudCategory category}) => categories.doc(category.categoryName).collection(FirestoreConstants.categoryItemsCollectionPathName).snapshots().map((event) => event.docs.map((snapshot) => CloudCategoryItem.fromSnapshot(snapshot, category,)));

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

  Stream<Iterable<ChatUser>> allFavoriteUsers({
    required String userId,
  }) {
    return users
        .doc(userId)
        .collection(FirestoreConstants.favoriteUsersCollectionPath)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (snapshot) => ChatUser.fromSnapshot(snapshot),
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

  Future<void> removeUserFromFavoriteUsers({
    required String currentUserId,
    required ChatUser user,
  }) async {
    try {
      await users
          .doc(currentUserId)
          .collection(FirestoreConstants.favoriteUsersCollectionPath)
          .doc(user.id)
          .delete();
    } catch (e) {
      throw CouldNotDeleteUserFromFavoritesCollection();
    }
  }

  Future<void> addUserToFavoriteUsers({
    required String currentUserId,
    required ChatUser user,
  }) async {
    try {
      await users
          .doc(currentUserId)
          .collection(FirestoreConstants.favoriteUsersCollectionPath)
          .doc(user.id)
          .set({
        FirestoreConstants.favoriteUserId: user.id,
        FirestoreConstants.favoriteUserNickName: user.nickname,
        FirestoreConstants.favoriteUserProfileUrl: user.profileImageUrl,
        FirestoreConstants.favoriteUserAboutMe: user.aboutMe,
      });
    } catch (e) {
      throw CouldNotAddUserToFavoritesCollection();
    }
  }

  Future<bool> checkIfUserInFavorites({
    required String userId,
    required String currentUserId,
  }) async {
    final allFavorites = allFavoriteUsers(userId: currentUserId);
    List<ChatUser> list = List.empty();
    final Iterable<ChatUser> iterable;
    try {
      iterable = await allFavorites.first;
      list = iterable.toList();
      for (int i = 0; i < list.length; i++) {
        if (list.elementAt(i).id == userId) {
          return true;
        }
      }
      return false;
    } catch (e) {
      throw CouldNotCompleteFavoriteUserCheckChatException();
    }
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
