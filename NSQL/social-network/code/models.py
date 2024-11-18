from flask_login import UserMixin
from neomodel import (
    StructuredNode,
    StringProperty,
    IntegerProperty,
    ArrayProperty,
    RelationshipTo,
)


# Neo4j
class Person(StructuredNode):
    name = StringProperty(unique_index=True, required=True)
    age = IntegerProperty(required=True)
    hobbies = ArrayProperty()

    likes = RelationshipTo("Person", "LIKES")
    dislikes = RelationshipTo("Person", "DISLIKES")


# MongoDB
class MongoUser(UserMixin):
    def __init__(self, user_data):
        self.id = str(user_data["_id"])
        self.username = user_data["username"]

    def get_id(self):
        return self.id
