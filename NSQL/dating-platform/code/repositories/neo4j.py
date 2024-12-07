import os
from typing import List
from models import Person
from repositories.repository import Repository
from neomodel import config, db


class Neo4jRepository(Repository):
    _instance: "Neo4jRepository" = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def setup(self):
        self._setup_database()
        self._mock_data()
        return self

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

    def get_sleeps_with(self, username: str) -> List[Person]:
        query = """
        MATCH (friend:Person)-[:LIKES]->(user:Person), (user:Person)-[:SLEEPSWITH]->(friend:Person)
        WHERE user.name = $username
        RETURN friend
        """
        results, _ = self._db.cypher_query(query, {"username": username})
        sleeps_with = self._convert_query_results(results)
        return sleeps_with

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
        pepa.sleepsWith.connect(jana)
        michal.likes.connect(alena)
        alena.dislikes.connect(michal)
        alena.likes.connect(pepa)
        richard.likes.connect(alena)
