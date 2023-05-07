abstract class ViewEvent {
  const ViewEvent();
}

class ViewEventGoToItems extends ViewEvent {
  const ViewEventGoToItems();
}

class ViewEventGoToOrders extends ViewEvent {
  const ViewEventGoToOrders();
}

class ViewEventGoToHomePage extends ViewEvent {
  const ViewEventGoToHomePage();
}

class ViewEventGoToChats extends ViewEvent {
  const ViewEventGoToChats();
}

class ViewEventCreateNewOrder extends ViewEvent {
  const ViewEventCreateNewOrder();
}

class ViewEventGoToSettings extends ViewEvent {
  const ViewEventGoToSettings();
}
