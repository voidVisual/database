use Cb

// Create and insert the order documents
db.or.insertMany([
  {
    Order_id: 1,
    Cust_id: "A1",
    Cust_name: "Rohan",
    Phone_no: [9890151243, 8806048721],
    Email_id: "Rohan@gmail.com",
    Item_name: "Laptop",
    DtOfOrder: ISODate("2017-06-12T00:00:00Z"),
    Qty: 2,
    Amt: 90000,
    Status: "D"
  },
  {
    Order_id: 2,
    Cust_id: "B1",
    Cust_name: "raj",
    Phone_no: [9860151243, 8806048723],
    Item_name: "Watch",
    DtOfOrder: ISODate("2024-06-12T00:00:00Z"),
    Qty: 3,
    Amt: 15000,
    Status: "P"
  },
  {
    Order_id: 3,
    Cust_id: "C1",
    Cust_name: "Nina",
    Phone_no: [9960151243, 8706048723],
    Item_name: "Mobile",
    DtOfOrder: ISODate("2017-02-12T00:00:00Z"),
    Qty: 2,
    Amt: 30000,
    Status: "P"
  },
  {
    Order_id: 4,
    Cust_id: "B1",
    Cust_name: "Sneha",
    Phone_no: [860151243, 8806048723],
    Item_name: "T-shirt",
    DtOfOrder: ISODate("2017-08-22T00:00:00Z"),
    Qty: 6,
    Amt: 12000,
    Status: "D"
  },
  {
    Order_id: 5,
    Cust_id: "C1",
    Cust_name: "Pritam",
    Phone_no: [9960151243, 8706048723],
    Item_name: "Jio Router",
    DtOfOrder: ISODate("2017-02-12T00:00:00Z"),
    Qty: 3,
    Amt: 6000,
    Status: "P"
  }
])

// 1. Create simple indexes and try duplicate entry:
db.or.createIndex({Cust_id:1})
db.or.createIndex({Item_name:1})
db.or.getIndexes()

// 2. Create unique index on Order_id and attempt duplicate entry:
db.or.createIndex({Order_id:1}, {unique:true})

// 3. Create multikey index on phone_no and find customers with 2 phone numbers:
db.or.createIndex({Phone_no:1})
db.or.find({Phone_no:{$size:2}}).pretty()

// 4. Create sparse index on email_id and show effects:
db.or.find({Email_id:"Rohan@gmail.com"}).explain()
db.or.createIndex({Email_id:1},{sparse:true})
db.or.find({Email_id:"Rohan@gmail.com"}).explain()

// 5. Display all indexes and their size:
db.or.getIndexes()
db.or.totalIndexSize()

// 6. Delete all indexes:
db.or.dropIndexes()

// 7. Find order counts:
db.or.find({Status:'D'}).count()
db.or.find({Status:'P'}).count()

// 8. Display distinct customer names:
db.or.distinct("Cust_name")

// 9. Sort documents based on amount:
db.or.find().sort({Amt:1}).pretty()

// 10. Show orders placed by each customer:
db.or.aggregate([
    {$group: {_id: "$Cust_name", cnt_of_order: {$sum: 1}}}
])

// 11. Display customer IDs and pending order amounts:
db.or.aggregate([
    {$match: {Status: 'P'}}, 
    {$group: {_id: "$Cust_id", pend_amt: {$sum: "$Amt"}}},
    {$sort: {pend_amt: -1}}
])

// 12. Show delivered orders by customer ID:
db.or.aggregate([
    {$match: {Status: 'D'}},
    {$group: {_id: "$Cust_id", tot_amt: {$sum: "$Amt"}}},
    {$sort: {_id: 1}}
])

// 13. Show top three selling items:
db.or.aggregate([
    {$group: {_id: "$Item_name", totqty: {$sum: "$Qty"}}}, 
    {$sort: {totqty: -1}},
    {$limit: 3}
])

// 14. Find date with maximum orders:
db.or.aggregate([
    {$group: {_id: "$DtOfOrder", cnt_of_order: {$sum: 1}}},
    {$sort: {cnt_of_order: -1}},
    {$limit: 1}
])

// 15. Find customer with maximum orders:
db.or.aggregate([
    {$group: {_id: "$Cust_name", cnt_orderid: {$sum: 1}}},
    {$sort: {cnt_orderid: -1}},
    {$limit: 1}
])
