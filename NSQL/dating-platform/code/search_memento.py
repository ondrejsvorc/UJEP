from typing import List
from flask_login import current_user
from models import Person
from relationships import (
    DislikeStrategy,
    LikeStrategy,
    RelationshipContext,
    RelationshipStrategy,
)
import json
from app import neo4j

STRATEGY_MAPPING = {
    "LikeStrategy": LikeStrategy,
    "DislikeStrategy": DislikeStrategy,
}


class ChoiceMemento:
    def __init__(self, strategy, friend_name):
        self._strategy = strategy
        self._friend_name = friend_name

    @property
    def strategy(self):
        return self._strategy

    @property
    def friend_name(self):
        return self._friend_name

    def serialize(self):
        return {
            "strategy": self._strategy.__class__.__name__,
            "friend_name": self._friend_name,
        }

    @classmethod
    def deserialize(cls, data):
        strategy_class = STRATEGY_MAPPING.get(data["strategy"])
        strategy = strategy_class()
        return cls(strategy, data["friend_name"])


class Choice:
    def __init__(self, strategy: RelationshipStrategy):
        self._strategy = strategy

    def save(self, friend_name):
        return ChoiceMemento(self._strategy, friend_name)

    def restore(self, memento: ChoiceMemento):
        context = RelationshipContext(memento.strategy)
        context.disconnect(
            neo4j.get_user_node(current_user.username),
            neo4j.get_user_node(memento.friend_name),
        )


class ChoiceCaretaker:
    def __init__(self, history: List[ChoiceMemento] = []):
        self._history = list(history)

    def save(self, choice: Choice, friend_name):
        memento = choice.save(friend_name)
        self._history.append(memento)

    def undo(self, choice: Choice):
        if not self.can_undo():
            return
        memento = self._history.pop()
        choice.restore(memento)

    def can_undo(self):
        return len(self._history) > 0

    def get_history(self):
        return self._history

    def set_history(self, history):
        self._history = history

    def serialize_history(self):
        return json.dumps([memento.serialize() for memento in self._history])

    @classmethod
    def deserialize_history(cls, data):
        history = [ChoiceMemento.deserialize(memento) for memento in json.loads(data)]
        return cls(history)
