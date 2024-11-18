from flask import Flask, render_template, request, redirect
from random import choice
from repositories import MongoRepository, Neo4jRepository, RedisRepository

app = Flask(__name__)

neo4j = Neo4jRepository()
mongo = MongoRepository()
redis = RedisRepository()

logged_user = "Pepa"


@app.route("/login")
def login():
    return render_template("login.html")


@app.route("/")
@app.route("/home")
def home():
    logged_user_info = neo4j.get_logged_user(logged_user)
    num_of_matches = len(neo4j.get_matches(logged_user))
    num_of_available_matches = len(neo4j.get_available_matches(logged_user))
    return render_template(
        "home.html",
        profile=logged_user_info,
        num_of_matches=num_of_matches,
        num_of_available_matches=num_of_available_matches,
    )


@app.route("/matches")
def matches():
    matches = neo4j.get_matches(logged_user)
    return render_template("matches.html", profiles=matches)


@app.route("/search", methods=["GET", "POST"])
def search():
    if request.method == "GET":
        available_matches = neo4j.get_available_matches(logged_user)
        random_profile = choice(available_matches) if available_matches else None
        return render_template("search.html", profile=random_profile)

    date_choice = request.form.get("date_choice")
    friend_name = request.form.get("friend_name")

    user_node = neo4j.get_user_node(logged_user)
    friend_node = neo4j.get_user_node(friend_name)

    if date_choice == "like":
        user_node.likes.connect(friend_node)
    elif date_choice == "dislike":
        user_node.dislikes.connect(friend_node)

    return redirect("/search")


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
