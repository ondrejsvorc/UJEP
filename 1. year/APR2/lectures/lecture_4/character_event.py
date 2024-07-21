from character_date import CharacterDate


class CharacterEvent:
    def __init__(
        self,
        from_date: CharacterDate,
        to_date: CharacterDate,
        description: str,
        *,
        lokace: str = None,
    ):
        pass

    @staticmethod
    def from_dict(json_dict: dict) -> "CharacterEvent":
        pass

    def to_dict(self) -> "dict":
        pass
