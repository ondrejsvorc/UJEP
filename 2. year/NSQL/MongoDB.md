### Resources
- [MongoDB - Cheat Sheet](https://www.mongodb.com/developer/products/mongodb/cheat-sheet/)
- [MongoDB - Official Documentation](https://docs.mongodb.com/](https://docs.mongodb.com/))
- [MongoDB - PyMongo Official](https://www.mongodb.com/resources/languages/python)
- [MongoDB - PyMongo W3Schools](https://www.w3schools.com/python/python_mongodb_getstarted.asp)
- [MongoDB - Kódím.cz](https://kodim.cz/czechitas/python-pro-databaze/mongo-db)

### Collection Methods
- **`db.collection.find()`**: Retrieve documents from a collection.
- **`db.collection.findOne()`**: Retrieve a single document from a collection.
- **`db.collection.insertOne()`**: Insert a single document into a collection.
- **`db.collection.insertMany()`**: Insert multiple documents into a collection.
- **`db.collection.updateOne()`**: Update a single document that matches a filter.
- **`db.collection.updateMany()`**: Update multiple documents that match a filter.
- **`db.collection.deleteOne()`**: Delete a single document that matches a filter.
- **`db.collection.deleteMany()`**: Delete multiple documents that match a filter.
- **`db.collection.countDocuments()`**: Count the number of documents that match a filter.
- **`db.collection.distinct()`**: Find distinct values for a field.
- **`db.collection.aggregate()`**: Perform aggregation operations on a collection.
- **`db.collection.findOneAndUpdate()`**: Find a document and update it.
- **`db.collection.findOneAndReplace()`**: Find a document and replace it.
- **`db.collection.findOneAndDelete()`**: Find a document and delete it.

### Database Methods
- **`db.getCollection()`**: Get a collection from a database.
- **`db.getCollectionNames()`**: Get a list of collection names in a database.
- **`db.createCollection()`**: Create a new collection in a database.
- **`db.dropCollection()`**: Drop a collection from a database.
- **`db.dropDatabase()`**: Drop the current database.

### Cursor Methods
- **`cursor.toArray()`**: Convert the cursor to an array.
- **`cursor.forEach()`**: Iterate over each document in the cursor.
- **`cursor.limit()`**: Limit the number of documents returned by the cursor.
- **`cursor.skip()`**: Skip a specified number of documents.
- **`cursor.sort()`**: Sort the documents returned by the cursor.

### Aggregation Operators
- **`$match`**: Filter documents based on specified criteria.
- **`$group`**: Group documents by a specified identifier.
- **`$sort`**: Sort documents.
- **`$project`**: Include or exclude fields in the output documents.
- **`$limit`**: Limit the number of documents in the result.
- **`$skip`**: Skip a specified number of documents.
- **`$lookup`**: Perform a left outer join with another collection.

### Index Methods
- **`db.collection.createIndex()`**: Create an index on a collection.
- **`db.collection.dropIndex()`**: Drop an index from a collection.
- **`db.collection.getIndexes()`**: List all indexes on a collection.