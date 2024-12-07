from flask import Blueprint, redirect, render_template, url_for
from flask_login import current_user, login_required
from app import neo4j

blueprint = Blueprint("home", __name__)


@blueprint.route("/")
@blueprint.route("/home")
@login_required
def home():
    if not current_user.is_authenticated:
        return redirect(url_for("auth.login"))
    user = neo4j.get_user_node(current_user.username)
    num_of_matches = len(neo4j.get_matches(current_user.username))
    num_of_available_matches = len(neo4j.get_available_matches(current_user.username))
    return render_template(
        "home.html",
        profile=user,
        num_of_matches=num_of_matches,
        num_of_available_matches=num_of_available_matches,
    )
