from abc import ABC, abstractmethod
from models import Person


class RelationshipStrategy(ABC):
    @abstractmethod
    def connect(self, user: Person, other: Person):
        pass


class LikeStrategy(RelationshipStrategy):
    def connect(self, user: Person, other: Person):
        user.likes.connect(other)


class DislikeStrategy(RelationshipStrategy):
    def connect(self, user: Person, other: Person):
        user.dislikes.connect(other)


class UserRelationshipContext:
    def __init__(self, strategy: RelationshipStrategy):
        self._strategy = strategy

    def connect_users(self, user: Person, other: Person):
        return self._strategy.connect(user, other)