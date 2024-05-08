from abc import ABC, abstractmethod
import random
from typing import Generic, Tuple, TypeVar
from weapons import Bow, Sword, Weapon

T = TypeVar("T", bound="Weapon")


class Soldier(ABC, Generic[T]):
    def __init__(
        self,
        name: str,
        armor: int,
        health: int,
        strength: float,
        weapon: T,
    ):
        self.name = name
        self.armor = armor
        self.health = health
        self.strength = strength
        self.weapon = weapon
        self.position = (0.0, 0.0)

    @abstractmethod
    def attack(self, enemy: "Soldier"):
        raise NotImplemented("Abstract method")

    @abstractmethod
    def defend(self, damage: int):
        raise NotImplemented("Abstract method")

    def move(self, coordinates: Tuple[float, float]):
        self.position = coordinates


class Warrior(Soldier[Sword]):
    def __init__(
        self,
        name: str,
        armor: int,
        health: int,
        strength: float,
        weapon: Sword,
    ):
        super().__init__(name, armor, health, strength, weapon)

    def attack(self, enemy: Soldier):
        damage = self.weapon.damage + self.strength
        print(f"{self.name} attacks with damage: {damage}")
        enemy.defend(damage)

    def defend(self, damage: int):
        effective_damage = abs(self.armor - damage)
        print(f"Effective damage: {effective_damage}")
        self.health = max(0, self.health - effective_damage)
        print(f"{self.name} defends with health: {self.health}")


class Marksman(Soldier[Bow]):
    def __init__(
        self,
        name: str,
        armor: int,
        health: int,
        strength: float,
        weapon: Bow,
    ):
        super().__init__(name, armor, health, strength, weapon)

    def attack(self, enemy: Soldier):
        damage = self.weapon.damage + self.strength
        accuracy = self.weapon.accuracy / 100.0
        hit = random.random() < accuracy
        if hit:
            enemy.defend(damage)

    def defend(self, damage: int):
        effective_damage = abs(self.armor - damage)
        print(f"Effective damage: {effective_damage}")
        self.health = max(0, self.health - effective_damage)
        print(f"{self.name} defends with health: {self.health}")

    def reload(self):
        self.weapon.arrows = 5
