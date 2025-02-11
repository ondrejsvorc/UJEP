import logging
from flask import Blueprint, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from app import neo4j
from relationships import RelationshipContext, SleepsWithStrategy

blueprint = Blueprint("matches", __name__)

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)


@blueprint.route("/matches", methods=["GET"])
@login_required
def matches():
    if not current_user.is_authenticated:
        return redirect(url_for("auth.login"))
    matches = neo4j.get_matches(current_user.username)
    return render_template("matches.html", profiles=matches)


@blueprint.route("/matches/sleepsWith", methods=["GET"])
@login_required
def sleepsWith():
    if not current_user.is_authenticated:
        return redirect(url_for("auth.login"))

    matches = neo4j.get_matches(current_user.username)
    sleeps_with = neo4j.get_sleeps_with(current_user.username)

    return render_template("sleepsWith.html", matches=matches, sleepsWith=sleeps_with)


@blueprint.route("/matches/sleepsWith", methods=["POST"])
@login_required
def sleepsWith_post():
    friend_name = request.form.get("friend_name")
    username = current_user.username

    user = neo4j.get_user_node(username)
    friend = neo4j.get_user_node(friend_name)

    strategy = SleepsWithStrategy()
    context = RelationshipContext(strategy)
    context.connect(user, friend)

    return redirect(url_for("matches.sleepsWith"))


@blueprint.route("/matches/sleeps_with/<friend_name>", methods=["POST"])
@login_required
def sleepsWith_delete(friend_name):
    username = current_user.username
    user = neo4j.get_user_node(username)
    friend = neo4j.get_user_node(friend_name)

    strategy = SleepsWithStrategy()
    context = RelationshipContext(strategy)
    context.disconnect(user, friend)

    return redirect(url_for("matches.sleepsWith"))


@blueprint.route("/matches/potential_disease", methods=["POST"])
@login_required
def potential_disease():
    username = current_user.username
    neo4j.set_potential_disease(username)
    return redirect(url_for("matches.sleepsWith"))
