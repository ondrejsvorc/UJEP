import os
from typing import List
from bson import ObjectId
from dotenv import load_dotenv
from pymongo import MongoClient
from neomodel import config, db
from redis import Redis
from models import MongoUser, Person

load_dotenv()


class Neo4jRepository:
    _instance = None

    def __init__(self):
        self._mock_data()

    def __new__(cls):
        print(os.getenv("NEO4J_DATABASE_URL"))
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            config.DATABASE_URL = os.getenv("NEO4J_DATABASE_URL")
            cls._instance._db = db
        return cls._instance

    def get_user_node(self, username: str) -> Person:
        return Person.nodes.get(name=username)

    def get_matches(self, username: str) -> List[Person]:
        query = """
        MATCH (friend:Person)-[:LIKES]->(user:Person)-[:LIKES]->(friend:Person)
        WHERE user.name = $username
        RETURN friend
        """
        results, _ = self._db.cypher_query(query, {"username": username})
        return [Person.inflate(row[0]) for row in results]

    def get_available_matches(self, username: str) -> List[Person]:
        query = """
        MATCH (user:Person), (friend:Person)
        WHERE user.name = $username
        AND NOT (user)-[:LIKES]->(friend)
        AND NOT (friend)-[:DISLIKES]->(user)
        AND NOT (user)-[:DISLIKES]->(friend)
        AND NOT friend.name = $username
        RETURN friend.name, friend.age, friend.hobbies
        """
        results, _ = self._db.cypher_query(query, {"username": username})
        return [Person(name=row[0], age=row[1], hobbies=row[2]) for row in results]

    def _mock_data(self):
        self._db.cypher_query("MATCH (n) DETACH DELETE n")
        pepa = Person(name="Pepa", age=34, hobbies=["programming", "running"]).save()
        jana = Person(name="Jana", age=30, hobbies=["cats", "running"]).save()
        michal = Person(name="Michal", age=38, hobbies=["partying", "cats"]).save()
        alena = Person(name="Alena", age=32, hobbies=["kids", "cats"]).save()
        richard = Person(name="Richard", age=33, hobbies=["partying", "cats"]).save()
        pepa.likes.connect(jana)
        jana.likes.connect(pepa)
        michal.likes.connect(alena)
        alena.dislikes.connect(michal)
        alena.likes.connect(pepa)
        richard.likes.connect(alena)


class MongoRepository:
    _instance = None

    def __init__(self):
        self._mock_data()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._db = MongoClient(
                host=os.getenv("MONGO_HOST"),
                port=int(os.getenv("MONGO_PORT")),
                username=os.getenv("MONGO_USERNAME"),
                password=os.getenv("MONGO_PASSWORD"),
                authSource=os.getenv("MONGO_AUTH_SOURCE"),
            )
        return cls._instance

    def get_user_by_id(self, user_id):
        users_collection = self._db["social_media"]["users"]
        return users_collection.find_one({"_id": ObjectId(user_id)})

    def verify_user(self, username, password):
        users_collection = self._db["social_media"]["users"]
        user_data = users_collection.find_one(
            {"username": username, "password": password}
        )
        if user_data:
            return MongoUser(user_data)
        return None

    def _mock_data(self):
        users_collection = self._db["social_media"]["users"]
        users_collection.delete_many({})
        mock_users = [
            {
                "username": "Pepa",
                "password": "123",
                "age": 34,
                "hobbies": ["programming", "running"],
            },
            {
                "username": "Jana",
                "password": "123",
                "age": 30,
                "hobbies": ["cats", "running"],
            },
            {
                "username": "Michal",
                "password": "123",
                "age": 38,
                "hobbies": ["partying", "cats"],
            },
            {
                "username": "Alena",
                "password": "123",
                "age": 32,
                "hobbies": ["kids", "cats"],
            },
            {
                "username": "Richard",
                "password": "123",
                "age": 33,
                "hobbies": ["partying", "cats"],
            },
        ]
        users_collection.insert_many(mock_users)


class RedisRepository:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._db = Redis(
                host=os.getenv("REDIS_HOST"),
                port=int(os.getenv("REDIS_PORT")),
                password=os.getenv("REDIS_PASSWORD"),
            )
        return cls._instance
