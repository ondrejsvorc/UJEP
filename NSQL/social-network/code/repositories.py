from abc import ABC
from enum import Enum
import os
from typing import Any, Dict, List, Optional
from bson import ObjectId
from pymongo import MongoClient
from pymongo.collection import Collection
from neomodel import config, db
from redis import Redis
from models import MongoUser, Person


class Repository(ABC):
    pass


class Neo4jRepository(Repository):
    _instance: "Neo4jRepository" = None

    def __init__(self):
        self._setup_database()
        self._mock_data()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def get_all_persons(self) -> List[Person]:
        query = """
        MATCH (p:Person)
        RETURN p
        """
        results, _ = self._db.cypher_query(query)
        return [Person.inflate(row[0]) for row in results]

    def get_matches(self, username: str) -> List[Person]:
        query = """
        MATCH (friend:Person)-[:LIKES]->(user:Person)-[:LIKES]->(friend:Person)
        WHERE user.name = $username
        RETURN friend
        """
        results, _ = self._db.cypher_query(query, {"username": username})
        matches = self._convert_query_results(results)
        return matches

    def get_available_matches(self, username: str) -> List[Person]:
        query = """
        MATCH (user:Person), (friend:Person)
        WHERE user.name = $username
        AND NOT (user)-[:LIKES]->(friend)
        AND NOT (friend)-[:DISLIKES]->(user)
        AND NOT (user)-[:DISLIKES]->(friend)
        AND NOT friend.name = $username
        RETURN friend
        """
        results, _ = self._db.cypher_query(query, {"username": username})
        available_matches = self._convert_query_results(results)
        return available_matches

    def get_user_node(self, username: str) -> Person:
        return Person.nodes.get(name=username)

    def _convert_query_results(self, results: List[tuple]) -> List[Person]:
        return [Person.inflate(row[0]) for row in results] if results else []

    def _setup_database(self):
        config.DATABASE_URL = os.getenv("NEO4J_DATABASE_URL")
        self._db = db

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


class MongoRepository(Repository):
    _instance = None

    def __init__(self):
        self._setup_database()
        self._mock_data()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def get_user_by_id(self, user_id: str) -> Optional[Any]:
        users = self._get_users_collection()
        user = users.find_one({"_id": ObjectId(user_id)})
        return MongoUser(user) if user else None

    def get_user(self, username: str, password: str) -> Optional[MongoUser]:
        users = self._get_users_collection()
        user = users.find_one({"username": username, "password": password})
        return MongoUser(user) if user else None

    def _get_users_collection(self) -> Collection:
        return self._db["social_media"]["users"]

    def _setup_database(self):
        self._db = MongoClient(
            host=os.getenv("MONGO_HOST"),
            port=int(os.getenv("MONGO_PORT")),
            username=os.getenv("MONGO_USERNAME"),
            password=os.getenv("MONGO_PASSWORD"),
            authSource=os.getenv("MONGO_AUTH_SOURCE"),
        )

    def _mock_data(self):
        users = self._db["social_media"]["users"]
        users.delete_many({})
        neo4j = Neo4jRepository()
        persons = neo4j.get_all_persons()
        mock_users = [
            {
                "username": person.name,
                "password": "123",
                "age": person.age,
                "hobbies": person.hobbies,
            }
            for person in persons
        ]
        users.insert_many(mock_users)


class RedisRepository(Repository):
    _instance = None

    def __init__(self):
        self._setup_database()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def _setup_database(self):
        self._db = Redis(
            host=os.getenv("REDIS_HOST"),
            port=int(os.getenv("REDIS_PORT")),
            password=os.getenv("REDIS_PASSWORD"),
        )


class DbType(Enum):
    MONGO = "mongo"
    NEO4J = "neo4j"
    REDIS = "redis"


class DbFactory:
    def __init__(self):
        self._dbs: Dict[DbType, Repository] = {
            DbType.MONGO: MongoRepository,
            DbType.NEO4J: Neo4jRepository,
            DbType.REDIS: RedisRepository,
        }

    def create_db(self, type: DbType) -> Repository:
        return self._dbs[type]()
