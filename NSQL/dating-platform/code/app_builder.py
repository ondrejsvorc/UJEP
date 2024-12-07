import os
from typing import Optional
from dotenv import load_dotenv
from flask import Flask
from flask_login import LoginManager
from flask_mail import Mail
from repositories.mongo import MongoRepository
from repositories.neo4j import Neo4jRepository
from repositories.redis import RedisRepository
from repositories.factory import (
    MongoRepositoryFactory,
    Neo4jRepositoryFactory,
    RedisRepositoryFactory,
)
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class InitializationError(Exception):
    def __init__(self, service_name: str, message: str):
        super().__init__(f"Failed to initialize {service_name}: {message}")
        self.service_name = service_name
        self.message = message


class AppBuilder:
    def __init__(self):
        self._app = Flask(__name__)
        self._mail: Optional[Mail] = None
        self._neo4j: Optional[Neo4jRepository] = None
        self._mongo: Optional[MongoRepository] = None
        self._redis: Optional[RedisRepository] = None

    def _add_secret_key(self):
        load_dotenv()
        secret_key = os.getenv("SECRET_SESSION_KEY")
        if not secret_key:
            raise InitializationError("Secret Key", "SECRET_SESSION_KEY is missing.")
        self._app.secret_key = secret_key
        logger.info("Secret key initialized.")

    def _add_mail(self):
        try:
            self._mail = Mail(self._app)
        except Exception as e:
            raise InitializationError("Mail Service", str(e))

    def _add_auth(self):
        try:
            login_manager = LoginManager()
            login_manager.init_app(self._app)
            login_manager.login_view = "auth.login"
            logger.info("Authentication manager initialized.")
        except Exception as e:
            raise InitializationError("Authentication Manager", str(e))

    def _add_neo4j(self):
        try:
            factory = Neo4jRepositoryFactory()
            self._neo4j = factory.create_repository()
            logger.info("Neo4j database initialized.")
        except Exception as e:
            raise InitializationError("Neo4j Database", str(e))

    def _add_mongo(self):
        try:
            factory = MongoRepositoryFactory()
            self._mongo = factory.create_repository()
            logger.info("Mongo database initialized.")
        except Exception as e:
            raise InitializationError("Mongo Database", str(e))

    def _add_redis(self):
        try:
            factory = RedisRepositoryFactory()
            self._redis = factory.create_repository()
            logger.info("Redis database initialized.")
        except Exception as e:
            raise InitializationError("Redis Database", str(e))

    def build(self):
        try:
            self._add_secret_key()
            self._add_mail()
            self._add_auth()
            self._add_neo4j()
            self._add_mongo()
            self._add_redis()
        except InitializationError as e:
            logger.critical(f"App initialization failed: {e}")
            raise

        return self._app, self._mail, self._neo4j, self._mongo, self._redis
