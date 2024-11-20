import os
import random
from dotenv import load_dotenv
from flask import Flask, render_template, request, redirect, url_for
from repositories import MongoRepository, Neo4jRepository, RedisRepository
from flask_login import (
    LoginManager,
    login_user,
    login_required,
    logout_user,
    current_user,
)

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_SESSION_KEY")

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

neo4j = Neo4jRepository()
mongo = MongoRepository()
redis = RedisRepository()


@login_manager.user_loader
def load_user(user_id):
    return mongo.get_user_by_id(user_id)


@app.route("/login", methods=["GET"])
def login():
    if current_user.is_authenticated:
        return redirect(url_for("home"))
    return render_template("login.html")


@app.route("/login", methods=["POST"])
def login_post():
    username = request.form.get("username")
    password = request.form.get("password")
    user = mongo.get_user(username, password)
    if not user:
        return redirect(url_for("login"))
    login_user(user)
    return redirect(url_for("home"))


@app.route("/logout", methods=["POST"])
def logout_post():
    logout_user()
    return redirect(url_for("login"))


@app.route("/")
@app.route("/home")
@login_required
def home():
    if not current_user.is_authenticated:
        return redirect(url_for("login"))
    user = neo4j.get_user_node(current_user.username)
    num_of_matches = len(neo4j.get_matches(current_user.username))
    num_of_available_matches = len(neo4j.get_available_matches(current_user.username))
    return render_template(
        "home.html",
        profile=user,
        num_of_matches=num_of_matches,
        num_of_available_matches=num_of_available_matches,
    )


@app.route("/matches", methods=["GET"])
@login_required
def matches():
    if not current_user.is_authenticated:
        return redirect(url_for("login"))
    matches = neo4j.get_matches(current_user.username)
    return render_template("matches.html", profiles=matches)


@app.route("/search", methods=["GET"])
@login_required
def search():
    available_matches = neo4j.get_available_matches(current_user.username)
    random_profile = random.choice(available_matches) if available_matches else None
    return render_template("search.html", profile=random_profile)


@app.route("/search", methods=["POST"])
@login_required
def search_post():
    friend_name = request.form.get("friend_name")
    choice = request.form.get("date_choice")

    user = neo4j.get_user_node(current_user.username)
    friend = neo4j.get_user_node(friend_name)

    if choice == "like":
        user.likes.connect(friend)
    elif choice == "dislike":
        user.dislikes.connect(friend)

    return redirect(url_for("search_get"))


@app.route("/<path:invalid_path>")
def handle_invalid_route(invalid_path):
    if not current_user.is_authenticated:
        return redirect(url_for("login"))
    return redirect(url_for("home"))


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
