import os
from redis import Redis
from repositories.repository import Repository


class RedisRepository(Repository):
    _instance: "RedisRepository" = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def setup(self):
        self._setup_database()
        return self

    def _setup_database(self):
        self._db = Redis(
            host=os.getenv("REDIS_HOST"),
            port=int(os.getenv("REDIS_PORT")),
            password=os.getenv("REDIS_PASSWORD"),
        )
