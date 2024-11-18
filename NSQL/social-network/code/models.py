from neomodel import (
    StructuredNode,
    StringProperty,
    IntegerProperty,
    ArrayProperty,
    RelationshipTo,
)


class Person(StructuredNode):
    name = StringProperty(unique_index=True, required=True)
    age = IntegerProperty(required=True)
    hobbies = ArrayProperty()

    likes = RelationshipTo("Person", "LIKES")
    dislikes = RelationshipTo("Person", "DISLIKES")
