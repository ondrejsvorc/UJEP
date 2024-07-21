from soldiers import Marksman, Warrior
from weapons import Bow, Sword

if __name__ == "__main__":
    warrior = Warrior(
        name="Gerald",
        armor=5,
        health=100,
        strength=5.0,
        weapon=Sword(damage=15),
    )
    marksman = Marksman(
        name="Maria",
        armor=10,
        health=100,
        strength=5.0,
        weapon=Bow(damage=15, accuracy=100, arrows=5),
    )

    enemy = Warrior(
        name="Enemy",
        armor=5,
        health=100,
        strength=0.8,
        weapon=Sword(damage=10),
    )

    warrior.attack(enemy)
    assert enemy.health == 85, "Warrior's attack should decrease enemy's health"

    marksman.attack(enemy)
    assert enemy.health == 70, "Marksman's attack should decrease enemy's health"

    marksman.reload()
    assert marksman.weapon.arrows == 5, "Marksman's reload should reset arrows to 5"

    warrior.move((1.0, 2.0))
    assert warrior.position == (1.0, 2.0), "Warrior's move should update position"

    marksman.defend(15)
    assert (
        marksman.health == 95
    ), "Marksman's defend should decrease health by damage minus armor"

    warrior.defend(10)
    assert (
        warrior.health == 95
    ), "Warrior's defend should decrease health by damage minus armor"
