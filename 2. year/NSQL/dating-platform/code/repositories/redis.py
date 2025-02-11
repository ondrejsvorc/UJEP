from enum import Enum
import os
from redis import Redis
from repositories.repository import Repository


class RedisKey(Enum):
    MATCHES = "matches"
    AVAILABLE_MATCHES = "available_matches"


class RedisRepository(Repository):
    _instance: "RedisRepository" = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def setup(self):
        self._setup_database()
        return self

    def generate_key(self, key: RedisKey, identifier: str) -> str:
        return f"{key.value}:{identifier}"

    def delete(self, key: str):
        self._db.delete(key)

    def get(self, key: str):
        return self._db.get(key)

    def set(self, key: str, value, ex=3600):
        self._db.set(key, value, ex)

    def decr(self, key: str):
        self._db.decr(key)

    def incr(self, key: str):
        self._db.incr(key)

    def _setup_database(self):
        self._db = Redis(
            host=os.getenv("REDIS_HOST"),
            port=int(os.getenv("REDIS_PORT")),
            password=os.getenv("REDIS_PASSWORD"),
            decode_responses=True,
        )
