import json
from flask import Flask, redirect, render_template, request, make_response
from redis import Connection, Redis
from pymongo import MongoClient
from helpers import add_pizza, delete_pizza, get_pizza, get_pizzas, update_pizza
from rq import Queue, Worker
import logging

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
redis = Redis(host="redis", port=6379)
redis_queue = Queue(connection=redis)
mongo = MongoClient(
    host="mongodb", port=27017, username="admin", password="admin", authSource="admin"
)
db = mongo["somedb"]
pizzas_collection = db["pizzas"]
storage = db["storage"]
sensor_1 = {"id": "0001", "name": "Temp"}
storage.insert_one(sensor_1)


# 1. Cache (Redis a MongoDB)
@app.route("/sensor/<sensor_id>", methods=["GET"])
def get_sensor(sensor_id):
    sensor_data = redis.get(f"sensor:{sensor_id}")
    if sensor_data:
        return (f"Z Redisu: {sensor_data.decode('utf-8')}", 200)

    sensor = storage.find_one({"id": sensor_id})
    if sensor:
        sensor["_id"] = str(sensor["_id"])
        redis.set(f"sensor:{sensor_id}", json.dumps(sensor))
        return f"Z MongoDB: {sensor}", 200

    return f"Data senzoru s id {sensor_id} nebyla nalezena", 404


# 2. Counter
@app.route("/", methods=["GET"])
def home():
    # redis.delete("homepage_requests")
    redis.incr("homepage_requests")
    counter = str(redis.get("homepage_requests"), "utf-8")
    return render_template("home.html", test=counter)


# 3. Cache webové stránky
@app.route("/page")
def get_page():
    # redis.delete("cached_page")
    cached_page = redis.get("cached_page")
    if cached_page:
        logging.info("Načtení stránky z redisu.")
        return cached_page.decode("utf-8"), 200
    logging.info("Prvotní načtení.")
    page = render_template("page.html")
    redis.set("cached_page", page)
    return page, 200


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


## 4. Redis queue
def add_pizza_to_mongo(pizza):
    logging.info("Přidávám pizzu do MongoDB...")
    pizzas_collection.insert_one(pizza)
    print(f"Inserted pizza: {pizza}")


@app.route("/add-pizza", methods=["POST"])
def add_pizza_post():
    name = request.form.get("pizzaName")
    price = int(request.form.get("pizzaPrice"))

    pizza = {"name": name, "price": price}
    logging.info("Přidávám pizzu do Redis Queue...")
    redis_queue.enqueue(add_pizza_to_mongo, pizza)

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
    app.run(host="0.0.0.0", port=5000, debug=True)
    w = Worker(["default"], connection=Redis(host="redis", port=6379))
    w.work()
