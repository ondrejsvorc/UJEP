from flask import Blueprint, redirect, render_template, url_for
from flask_login import current_user, login_required
from app import neo4j, redis
from repositories.redis import RedisKey

blueprint = Blueprint("home", __name__)


@blueprint.route("/")
@blueprint.route("/home")
@login_required
def home():
    if not current_user.is_authenticated:
        return redirect(url_for("auth.login"))

    username = current_user.username
    matches_key = redis.generate_key(RedisKey.MATCHES, username)
    available_matches_key = redis.generate_key(RedisKey.AVAILABLE_MATCHES, username)

    matches = redis.get(matches_key)
    if not matches:
        matches = len(neo4j.get_matches(username))
        redis.set(matches_key, matches)

    available_matches = redis.get(available_matches_key)
    if not available_matches:
        available_matches = len(neo4j.get_available_matches(username))
        redis.set(available_matches_key, available_matches)

    return render_template(
        "home.html",
        profile=neo4j.get_user_node(username),
        num_of_matches=matches,
        num_of_available_matches=available_matches,
    )
