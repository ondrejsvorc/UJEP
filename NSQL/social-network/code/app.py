from neomodel import (
    db,
    config,
    StructuredNode,
    StringProperty,
    IntegerProperty,
    ArrayProperty,
    RelationshipTo,
)
from flask import Flask, render_template, request, redirect
from random import choice


app = Flask(__name__)
config.DATABASE_URL = "bolt://neo4j:adminpass@neo4j:7687"

logged_user = "Pepa"


class Person(StructuredNode):
    name = StringProperty(unique_index=True, required=True)
    age = IntegerProperty(required=True)
    hobbies = ArrayProperty()

    likes = RelationshipTo("Person", "LIKES")
    dislikes = RelationshipTo("Person", "DISLIKES")


def mock_data():
    db.cypher_query("MATCH (n) DETACH DELETE n")

    pepa = Person(name="Pepa", age=34, hobbies=["programming", "running"]).save()
    jana = Person(name="Jana", age=30, hobbies=["cats", "running"]).save()
    michal = Person(name="Michal", age=38, hobbies=["partying", "cats"]).save()
    alena = Person(name="Alena", age=32, hobbies=["kids", "cats"]).save()
    richard = Person(name="Richard", age=33, hobbies=["partying", "cats"]).save()

    pepa.likes.connect(jana)
    jana.likes.connect(pepa)
    michal.likes.connect(alena)
    alena.dislikes.connect(michal)
    alena.likes.connect(pepa)
    richard.likes.connect(alena)


def get_user_node(username):
    return Person.nodes.get(name=username)


def get_logged_user_profile(username):
    return get_user_node(username)


def get_matches(username):
    query = """
    MATCH (friend:Person)-[:LIKES]->(user:Person)-[:LIKES]->(friend:Person)
    WHERE user.name = $username
    RETURN friend
    """
    results, _ = db.cypher_query(query, {"username": username})
    return [Person.inflate(row[0]) for row in results]


def available_matches(username):
    query = """
    MATCH (user:Person), (friend:Person)
    WHERE user.name = $username
    AND NOT (user)-[:LIKES]->(friend)
    AND NOT (friend)-[:DISLIKES]->(user)
    AND NOT (user)-[:DISLIKES]->(friend)
    AND NOT friend.name = $username
    RETURN friend.name, friend.age, friend.hobbies
    """
    results, _ = db.cypher_query(query, {"username": username})
    return [dict(name=row[0], age=row[1], hobbies=row[2]) for row in results]


# Routes
@app.route("/login")
def login():
    return render_template("login.html")


@app.route("/")
@app.route("/home")
def hello_world():
    logged_user_info = get_logged_user_profile(logged_user)
    num_of_matches = len(get_matches(logged_user))
    num_of_available_matches = len(available_matches(logged_user))
    return render_template(
        "home.html",
        profile=logged_user_info,
        num_of_matches=num_of_matches,
        num_of_available_matches=num_of_available_matches,
    )


@app.route("/matches")
def matches():
    matches = get_matches(logged_user)
    return render_template("matches.html", profiles=matches)


@app.route("/search", methods=["GET", "POST"])
def search():
    if request.method == "GET":
        potential_matches = available_matches(logged_user)
        random_profile = choice(potential_matches) if potential_matches else None
        return render_template("search.html", profile=random_profile)
    else:  # POST method
        date_choice = request.form.get("date_choice")
        friend_name = request.form.get("friend_name")

        user_node = get_user_node(logged_user)
        friend_node = get_user_node(friend_name)

        if date_choice == "like":
            user_node.likes.connect(friend_node)
        elif date_choice == "dislike":
            user_node.dislikes.connect(friend_node)

        return redirect("/search")


if __name__ == "__main__":
    mock_data()
    app.run(debug=True, host="0.0.0.0", port=5000)
