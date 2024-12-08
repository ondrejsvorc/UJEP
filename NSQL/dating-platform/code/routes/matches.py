from flask import Blueprint, current_app, redirect, render_template, url_for
from flask_login import current_user, login_required
from app import neo4j

blueprint = Blueprint("matches", __name__)


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
    sleeps_with = neo4j.get_sleeps_with(current_user.username)
    return render_template("sleepsWith.html", profiles=sleeps_with)
