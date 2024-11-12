// Insert documents
use db
db.orders.insertMany([
  { customerId: 1, orderDate: new Date("2024-01-10"), status: "D", price: 200, items: [{ product: "A", quantity: 2 }] },
  { customerId: 1, orderDate: new Date("2024-02-15"), status: "P", price: 150, items: [{ product: "B", quantity: 1 }] },
  { customerId: 2, orderDate: new Date("2024-01-20"), status: "D", price: 300, items: [{ product: "C", quantity: 3 }] },
  { customerId: 2, orderDate: new Date("2024-03-12"), status: "P", price: 250, items: [{ product: "D", quantity: 4 }] },
  { customerId: 3, orderDate: new Date("2024-02-01"), status: "D", price: 400, items: [{ product: "E", quantity: 5 }] }
])

// I. Display total price per customer
var mapFunction1 = function() { emit(this.customerId, this.price); };
var reduceFunction1 = function(customerId, prices) { return Array.sum(prices); };

db.orders.mapReduce(
  mapFunction1,
  reduceFunction1,
  { out: "totalPricePerCustomer" }
)

// II. Display total price per customer having status = D
var mapFunction2 = function() { if (this.status === "D") emit(this.customerId, this.price); };
var reduceFunction2 = function(customerId, prices) { return Array.sum(prices); };

db.orders.mapReduce(
  mapFunction2,
  reduceFunction2,
  { out: "totalPriceCustomerStatusD" }
)

// III. Display total price for status = P
var mapFunction3 = function() { if (this.status === "P") emit(this.status, this.price); };
var reduceFunction3 = function(status, prices) { return Array.sum(prices); };

db.orders.mapReduce(
  mapFunction3,
  reduceFunction3,
  { out: "totalPriceStatusP" }
)

// IV. Finding count of all keys in orders collection
var mapFunction4 = function() { for (var key in this) emit(key, 1); };
var reduceFunction4 = function(key, counts) { return Array.sum(counts); };

db.orders.mapReduce(
  mapFunction4,
  reduceFunction4,
  { out: "keyCounts" }
)
