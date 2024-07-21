import json
from flask import Flask, redirect, render_template, request, make_response
from helpers import add_pizza, delete_pizza, get_pizza, get_pizzas, update_pizza

app = Flask(__name__)


@app.route("/", methods=["GET"])
def home():
    return render_template("home.html")


@app.route("/pizzas", methods=["GET"])
def pizzas():
    return render_template("pizzas.html", menu=get_pizzas())


@app.route("/order-pizza", methods=["GET"])
def order_pizza_get():
    return render_template("order-pizza.html")


@app.route("/order-pizza", methods=["POST"])
def order_pizza_post():
    name = request.form.get("pizzaName")
    amount = int(request.form.get("pizzaAmount"))

    for pizza in get_pizzas():
        if pizza["name"] == name:
            total_price = amount * int(pizza["price"])
            break

    with open("invoice.txt", "w") as invoice_file:
        invoice_file.write(f"Pay {total_price} $")

    return redirect("/")


@app.route("/add-pizza", methods=["GET"])
def add_pizza_get():
    return render_template("add-pizza.html")


@app.route("/add-pizza", methods=["POST"])
def add_pizza_post():
    name = request.form.get("pizzaName")
    price = int(request.form.get("pizzaPrice"))

    pizza = {"name": name, "price": price}
    add_pizza(pizza)

    return redirect("/pizzas")


@app.route("/api/pizzas", methods=["GET"])
def api_get_pizzas():
    pizzas = get_pizzas()
    if pizzas is None:
        error = {"error": "Pizzas were not found."}
        return make_response(error, 404)
    return make_response(pizzas, 200)


@app.route("/api/pizza", methods=["GET"])
def api_get_pizza():
    name = request.args.get("name")
    pizza = get_pizza(name)
    if pizza is None:
        error = {"error": "Pizza was not found."}
        return make_response(json.dumps(error), 404)
    return make_response(pizza, 200)


@app.route("/api/add-pizza", methods=["POST"])
def api_add_pizza():
    name = request.args.get("name")
    price = request.args.get("price")
    if not name or not price:
        error = {"error": "Pizza name or price is missing."}
        return make_response(error, 404)

    new_pizza = {"name": name, "price": price}
    add_pizza(new_pizza)

    status = {"status": f"Pizza {name} was added successfully."}
    return make_response(json.dumps(status), 200)


@app.route("/api/update-pizza", methods=["PUT"])
def api_update_pizza():
    name = request.args.get("name")
    price = request.args.get("price")
    if not name or not price:
        error = {"error": "Pizza name or price is missing."}
        return make_response(error, 404)
    update_pizza(name, price)
    status = {"status": f"Pizza {name} was updated successfully."}
    return make_response(json.dumps(status), 200)


@app.route("/api/delete-pizza", methods=["DELETE"])
def api_delete_pizza():
    name = request.args.get("name")
    if not name:
        error = {"error": "Pizza name is missing."}
        return make_response(error, 404)
    delete_pizza(name)
    status = {"status": f"Pizza {name} was deleted successfully."}
    return make_response(json.dumps(status), 200)


if __name__ == "__main__":
    app.run(port=8000, debug=True)
