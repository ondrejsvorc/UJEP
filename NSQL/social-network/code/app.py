from flask import Flask, render_template, request, redirect, url_for
from random import choice
from models import MongoUser
from repositories import MongoRepository, Neo4jRepository, RedisRepository
from flask_login import (
    LoginManager,
    login_user,
    login_required,
    logout_user,
    current_user,
)

app = Flask(__name__)
app.secret_key = "session_secret_key"

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

neo4j = Neo4jRepository()
mongo = MongoRepository()
redis = RedisRepository()


@login_manager.user_loader
def load_user(user_id):
    user_data = mongo.get_user_by_id(user_id)
    return MongoUser(user_data) if user_data else None


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "GET" and not current_user.is_authenticated:
        return render_template("login.html")

    if request.method == "GET" and current_user.is_authenticated:
        return redirect(url_for("index"))

    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        user = mongo.verify_user(username, password)
        if user:
            login_user(user)
            return redirect(url_for("index"))


@app.route("/logout", methods=["GET", "POST"])
def logout():
    logout_user()
    return redirect(url_for("login"))


@app.route("/")
@app.route("/home")
@login_required
def index():
    if not current_user.is_authenticated:
        return redirect(url_for("login"))
    logged_user_info = neo4j.get_user_node(current_user.username)
    num_of_matches = len(neo4j.get_matches(current_user.username))
    num_of_available_matches = len(neo4j.get_available_matches(current_user.username))
    return render_template(
        "home.html",
        profile=logged_user_info,
        num_of_matches=num_of_matches,
        num_of_available_matches=num_of_available_matches,
    )


@app.route("/matches")
@login_required
def matches():
    if not current_user.is_authenticated:
        return redirect(url_for("login"))
    matches = neo4j.get_matches(current_user.username)
    return render_template("matches.html", profiles=matches)


@app.route("/search", methods=["GET", "POST"])
@login_required
def search():
    if not current_user.is_authenticated:
        return redirect(url_for("login"))
    if request.method == "GET":
        available_matches = neo4j.get_available_matches(current_user.username)
        random_profile = choice(available_matches) if available_matches else None
        return render_template("search.html", profile=random_profile)

    date_choice = request.form.get("date_choice")
    friend_name = request.form.get("friend_name")

    user_node = neo4j.get_user_node(current_user.username)
    friend_node = neo4j.get_user_node(friend_name)

    if date_choice == "like":
        user_node.likes.connect(friend_node)
    elif date_choice == "dislike":
        user_node.dislikes.connect(friend_node)

    return redirect("/search")


@app.route("/<path:invalid_path>")
def handle_invalid_route(invalid_path):
    if not current_user.is_authenticated:
        return redirect(url_for("login"))
    return redirect(url_for("index"))


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
