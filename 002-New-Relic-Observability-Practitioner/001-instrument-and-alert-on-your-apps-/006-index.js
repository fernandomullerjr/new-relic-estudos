
var order = req.body;
var itemCount = 0;
var orderTotal = 0;
order.items.forEach(function(item) { 
  itemCount += item.qty;
  orderTotal += item.price * item.qty;
});
newrelic.addCustomAttributes({
  'customer': order.deliverTo.name,
  'restaurant': order.restaurant.name,
  'itemCount': itemCount,
  'orderTotal': orderTotal
});

return res.status(201).send({ orderId: Date.now() });
});