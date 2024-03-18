from character_date import CharacterDate
from character_event import CharacterEvent


class Character:
    def __init__(
        self: str,
        name: str,
        dateOfBirth: CharacterDate,
        *,
        nickname: str = None,
        dateOfDeath: CharacterDate = None,
    ):
        pass

    @staticmethod
    def from_dict(json_dict: dict) -> "Character":
        pass

    def to_dict(self) -> "dict":
        pass

    def add_event(self, event: CharacterEvent):
        pass

    def get_events(
        self, from_date: CharacterDate, to_date: CharacterDate
    ) -> list[CharacterEvent]:
        pass

    def __repr__(self):
        pass
