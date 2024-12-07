from flask import Blueprint, request, render_template, redirect, url_for
from flask_login import login_user, current_user, logout_user

blueprint = Blueprint("auth", __name__)


@blueprint.route("/login", methods=["GET"])
def login():
    if current_user.is_authenticated:
        return redirect(url_for("home.home"))
    return render_template("login.html")


@blueprint.route("/login", methods=["POST"])
def login_post():
    from app import mongo

    username = request.form.get("username")
    password = request.form.get("password")
    user = mongo.get_user(username, password)
    if not user:
        return redirect(url_for("auth.login"))
    login_user(user)
    return redirect(url_for("home.home"))


@blueprint.route("/logout", methods=["POST"])
def logout_post():
    logout_user()
    return redirect(url_for("auth.login"))
