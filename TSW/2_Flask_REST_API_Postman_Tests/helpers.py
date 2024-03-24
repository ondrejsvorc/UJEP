import json


def get_pizzas() -> list:
    with open("data/pizzas.json", "r") as menu_file:
        menu_json = menu_file.read()
    return json.loads(menu_json)


def get_pizza(name):
    for pizza in get_pizzas():
        if pizza["name"] == name:
            return pizza


def add_pizza(pizza):
    pizzas = get_pizzas()
    pizzas.append(pizza)
    with open("data/pizzas.json", "w") as menu_file:
        menu_file.write(json.dumps(pizzas))


def update_pizza(name, price):
    pizzas = get_pizzas()
    for pizza in pizzas:
        if pizza["name"] == name:
            pizza["price"] = int(price)
            break
    with open("data/pizzas.json", "w") as menu_file:
        menu_file.write(json.dumps(pizzas))


def delete_pizza(name):
    pizzas = get_pizzas()
    for pizza in pizzas:
        if pizza["name"] == name:
            pizzas.remove(pizza)
            break
    with open("data/pizzas.json", "w") as menu_file:
        menu_file.write(json.dumps(pizzas))
