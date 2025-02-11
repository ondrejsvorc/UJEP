from abc import ABC, abstractmethod


class Repository(ABC):
    @abstractmethod
    def setup(self) -> "Repository":
        pass
