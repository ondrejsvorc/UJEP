import os
from typing import Any, Optional
from bson import ObjectId
from pymongo import MongoClient
from pymongo.collection import Collection
from repositories.neo4j import Neo4jRepository
from repositories.repository import Repository
from models import MongoUser


class MongoRepository(Repository):
    _instance: "MongoRepository" = None

    def __init__(self):
        self._setup_database()
        self._mock_data()

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def setup(self):
        self._setup_database()
        self._mock_data()
        return self

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
