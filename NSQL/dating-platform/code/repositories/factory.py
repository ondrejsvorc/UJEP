from abc import ABC, abstractmethod
from repositories.mongo import MongoRepository
from repositories.neo4j import Neo4jRepository
from repositories.redis import RedisRepository
from repositories.repository import Repository


class RepositoryFactory(ABC):
    @abstractmethod
    def create_repository(self) -> Repository:
        pass


class MongoRepositoryFactory(RepositoryFactory):
    def create_repository(self) -> MongoRepository:
        return MongoRepository().setup()


class Neo4jRepositoryFactory(RepositoryFactory):
    def create_repository(self) -> Neo4jRepository:
        return Neo4jRepository().setup()


class RedisRepositoryFactory(RepositoryFactory):
    def create_repository(self) -> RedisRepository:
        return RedisRepository().setup()
