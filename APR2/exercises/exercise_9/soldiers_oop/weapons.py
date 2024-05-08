class Weapon:
    def __init__(
        self,
        damage: float,
    ):
        self.damage = damage


class MeleeWeapon(Weapon):
    def __init__(
        self,
        damage: float,
    ):
        super().__init__(damage)


class DistanceWeapon(Weapon):
    def __init__(
        self,
        damage: float,
        accuracy: int,
    ):
        super().__init__(damage)
        self.accuracy = accuracy


class Sword(MeleeWeapon):
    def __init__(
        self,
        damage: float,
    ):
        super().__init__(damage)


class Bow(DistanceWeapon):
    def __init__(
        self,
        damage: float,
        accuracy: int,
        arrows: int,
    ):
        super().__init__(damage, accuracy)
        self.arrows = arrows
