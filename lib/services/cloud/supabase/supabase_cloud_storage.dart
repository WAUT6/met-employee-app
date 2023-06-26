import 'dart:async';

import 'package:metapp/services/chat/chat_user.dart';
import 'package:metapp/services/cloud/supabase/models/supabase_cloud_order_item.dart';
import 'package:metapp/services/cloud/supabase/supabase_cloud_exceptions.dart';
import 'package:metapp/services/cloud/supabase/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/supabase_cloud_category.dart';
import 'models/supabase_cloud_item.dart';
import 'models/supabase_cloud_order.dart';

class SupabaseCloudStorage {
  static final SupabaseCloudStorage _shared = SupabaseCloudStorage._sharedInstance();
  SupabaseCloudStorage._sharedInstance();
  factory SupabaseCloudStorage() => _shared;

final supabase = Supabase.instance.client;

//-------------Items---------------//
Future<SupabaseCloudItem> addItem() async {
  try {
    final data = await supabase.from(SupabaseConstants.items).insert({
      SupabaseConstants.itemName : '',
      SupabaseConstants.categoryId : '',
    }).select();
    return SupabaseCloudItem.fromJSON(data, data[SupabaseConstants.itemId],);
  } catch (e) {
    throw const CouldNotInsertItemIntoItemsTableSupabaseException();
  }
}

Future<void> deleteItem({required SupabaseCloudItem item,}) async {
  try {
    await supabase.from(SupabaseConstants.items).delete().eq(SupabaseConstants.itemId, item.itemId,);
  } catch (e) {
    throw const CouldNotDeleteItemFromItemsTableSupabaseException();
  }
}

Future<void> updateItemName({required SupabaseCloudItem item, required String newItemName,}) async {
  try {
    await supabase.from(SupabaseConstants.items).update({
      SupabaseConstants.itemName : newItemName,
    }).eq(SupabaseConstants.itemId, item.itemId);
  } catch (e) {
    throw const CouldNotUpdateItemNameSupabaseException();
  }
}

Future<void> updateItemCategory({required SupabaseCloudItem item, required String newCategory,}) async {
  try {
    await supabase.from(SupabaseConstants.items).update({
      SupabaseConstants.categoryId : newCategory,
    }).eq(SupabaseConstants.itemId, item.itemId);
  } catch (e) {
    throw const CouldNotUpdateItemCategorySupabaseException();
  }
}

//-------------Orders--------------//
Future<SupabaseCloudOrder> createNewOrder({required ChatUser user}) async {
  try {
    final data = await supabase.from(SupabaseConstants.orders).insert({
      SupabaseConstants.customerName : '',
      SupabaseConstants.employeeName : user.nickname,
    });
    return SupabaseCloudOrder.fromJSON(data, data[SupabaseConstants.orderId],);
  } catch (e) {
    throw const CouldNotInsertOrderIntoOrdersTableSupabaseException();
  }
}

Future<void> deleteOrder({required SupabaseCloudOrder order}) async {
  try {
    await supabase.from(SupabaseConstants.orders).delete().eq(SupabaseConstants.orderId, order.orderId,);
  } catch (e) {
    throw const CouldNotDeleteOrderFromOrdersTableSupabaseException();
  }
}

Future<void> updateCustomerName({required SupabaseCloudOrder order, required String newCustomerName,}) async {
  try {
    await supabase.from(SupabaseConstants.orders).update({
      SupabaseConstants.customerName : newCustomerName,
    }).eq(SupabaseConstants.orderId, order.orderId);
  } catch (e) {
    throw const CouldNotUpdateCustomerNameSupabaseException();
  }
}

Future<void> updateEmployeeName({required SupabaseCloudOrder order, required String newEmployeeName,}) async {
  try {
    await supabase.from(SupabaseConstants.orders).update({
      SupabaseConstants.employeeName : newEmployeeName,
    }).eq(SupabaseConstants.orderId, order.orderId,);
  } catch (e) {
    throw const CouldNotUpdateEmployeeNameSupabaseException();
  }
}

//-----------Order Items-----------//
Future<void> addNewOrderItem({required SupabaseCloudOrder order, required SupabaseCloudItem item,}) async {
  try {
    await supabase.from(SupabaseConstants.orderItems).insert({
      SupabaseConstants.orderId : order.orderId,
      SupabaseConstants.itemId : item.itemId,
      SupabaseConstants.quantity : '',
      SupabaseConstants.packaging : '',
    });
  } catch (e) {
    throw const CouldNotInsertOrderItemIntoOrderItemsTableSupabaseException();
  }
}

Future<void> updateOrderItemQuantity({required SupabaseCloudOrder order, required SupabaseCloudOrderItem orderItem, required int newQuantity,}) async {
  try {
    await supabase.from(SupabaseConstants.orderItems).update({
      SupabaseConstants.quantity : newQuantity,
    }).eq(SupabaseConstants.orderId, order.orderId).eq(SupabaseConstants.itemId, orderItem.itemId,);
  } catch (e) {
    throw const CouldNotUpdateOrderItemQuantitySupabaseException();
  }
}

Future<void> updateOrderItemPackaging({required SupabaseCloudOrder order, required SupabaseCloudItem orderItem, required String newPackaging,}) async {
  try {
    await supabase.from(SupabaseConstants.orderItems).update({
      SupabaseConstants.packaging : newPackaging,
    }).eq(SupabaseConstants.orderId, order.orderId).eq(SupabaseConstants.itemId, orderItem.itemId,);
  } catch (e) {
    throw const CouldNotUpdateOrderItemPackagingSupabaseException();
  }
}

//-----------Categories------------//
Future<SupabaseCloudCategory> createNewCategory() async {
  try {
    final data = await supabase.from(SupabaseConstants.categories).insert({
      SupabaseConstants.categoryName : '',
    }).select();
    return SupabaseCloudCategory.fromJSON(data, data[SupabaseConstants.categoryId],);
  } catch (e) {
    throw const CouldNotInsertCategoryIntoCategoriesTableSupabaseException();
  }
}

Future<void> deleteCategory({required SupabaseCloudCategory category}) async {
  try {
    await supabase.from(SupabaseConstants.categories).delete().eq(SupabaseConstants.categoryId, category.categoryId,);
  } catch (e) {
    throw const CouldNotDeleteCategoryFromCategoriesTableSupabaseException();
  }
}

Future<void> updateCategoryName({required SupabaseCloudCategory category, required String newCategoryName,}) async {
  try {
    await supabase.from(SupabaseConstants.categories).update({
      SupabaseConstants.categoryName : newCategoryName,
    }).eq(SupabaseConstants.categoryId, category.categoryId);
  } catch (e) {
    throw const CouldNotUpdateCategoryNameSupabaseException();
  }
}

}