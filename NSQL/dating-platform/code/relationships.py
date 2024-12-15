from abc import ABC, abstractmethod
from models import Person


class RelationshipStrategy(ABC):
    @abstractmethod
    def connect(self, user: Person, other: Person):
        pass

    @abstractmethod
    def disconnect(self, user: Person, other: Person):
        pass


class LikeStrategy(RelationshipStrategy):
    def connect(self, user: Person, other: Person):
        user.likes.connect(other)

    def disconnect(self, user: Person, other: Person):
        user.likes.disconnect(other)


class DislikeStrategy(RelationshipStrategy):
    def connect(self, user: Person, other: Person):
        user.dislikes.connect(other)

    def disconnect(self, user: Person, other: Person):
        user.dislikes.disconnect(other)


class SleepsWithStrategy(RelationshipStrategy):
    def connect(self, user: Person, other: Person):
        user.sleepsWith.connect(other)

    def disconnect(self, user: Person, other: Person):
        user.sleepsWith.disconnect(other)


class RelationshipContext:
    def __init__(self, strategy: RelationshipStrategy):
        self._strategy = strategy

    def connect_users(self, user: Person, other: Person):
        return self._strategy.connect(user, other)

    def disconnect_users(self, user: Person, other: Person):
        return self._strategy.disconnect(user, other)
