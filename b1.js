use C35511
// 1. Insert Multiple Documents
db.articles.insertMany([
  {
    "Title": "Alchemist",
    "Content": "Life lessons",
    "Author": "shri",
    "Author_age": 25,
    "DOP": ISODate("2016-05-13T00:00:00Z"),
    "Category": "novel",
    "Comment": [
      { "Name": "ramu", "Remarks": "Very Good" },
      { "Name": "Ravee", "Remarks": "Nice" }
    ]
  },
  {
    "Title": "The Ghost Prison",
    "Content": "Horror story",
    "Author": "krishna",
    "Author_age": 30,
    "DOP": ISODate("2018-07-23T00:00:00Z"),
    "Category": "Horror",
    "Comment": [
      { "Name": "aniket", "Remarks": "Mindblowing" },
      { "Name": "Tanu", "Remarks": "wow" }
    ]
  }
]);

// 2. Display All Records
db.articles.find().pretty();

// 3. Find First Document by Author
db.articles.findOne({ "Author": "krishna" });

// 4. Modify Specific Comment
db.articles.updateOne(
  { "Title": "Alchemist", "Comment.Name": "Ravee" },
  { $set: { "Comment.$.Remarks": "Mindblowing" } }
);

// 5. Insert with and without ObjectID

// With ObjectID
db.articles.insertOne({
  "_id": ObjectId("651ad76fa6d1b4c66fd829f1"),
  "Title": "Verity",
  "Content": "Thriller story",
  "Author": "Collen HOver",
  "Author_age": 35,
  "DOP": ISODate("2019-09-15T00:00:00Z"),
  "Category": "THriller",
  "Comment": []
});

// Without ObjectID
db.articles.insertOne({
  "Title": "Verity",
  "Content": "Thriller story",
  "Author": "rajeshr",
  "Author_age": 35,
  "DOP": ISODate("2019-09-15T00:00:00Z"),
  "Category": "THriller",
  "Comment": []
});

// 6. Insert with Specific ObjectID
db.articles.insertOne({
  "_id": ObjectId("651ad76fa6d1b4c66fd829f2"),
  "Title": "Silent Patient",
  "Content": "Story of a murder mystery",
  "Author": "Alex",
  "Author_age": 45,
  "DOP": ISODate("2022-11-10T00:00:00Z"),
  "Category": "Murder Mystery",
  "Comment": []
});

// 7. Add New Comment
db.articles.updateOne(
  { "Title": "Alchemist" },
  { $push: { "Comment": { "Name": "Amit", "Remarks": "Good Lesson" } } }
);

// 8. Delete Documents by Age Criteria
db.articles.deleteMany({ "Author_age": { $lt: 18 } });

// 9. Remove All Documents
db.articles.deleteMany({});

// 10. Delete Collection
db.articles.drop();
