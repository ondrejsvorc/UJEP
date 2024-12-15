import random
from flask import Blueprint, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from app import neo4j, redis
from repositories.redis import RedisKey
from relationships import DislikeStrategy, LikeStrategy, RelationshipContext

blueprint = Blueprint("search", __name__)


@blueprint.route("/search", methods=["GET"])
@login_required
def search():
    available_matches = neo4j.get_available_matches(current_user.username)
    random_profile = random.choice(available_matches) if available_matches else None
    return render_template("search.html", profile=random_profile)


@blueprint.route("/search", methods=["POST"])
@login_required
def search_post():
    username = current_user.username
    friend_name = request.form.get("friend_name")
    choice = request.form.get("date_choice")

    user = neo4j.get_user_node(username)
    friend = neo4j.get_user_node(friend_name)

    strategy = LikeStrategy() if choice == "like" else DislikeStrategy()
    context = RelationshipContext(strategy)
    context.connect_users(user, friend)

    redis.decr(redis.generate_key(RedisKey.AVAILABLE_MATCHES, username))

    return redirect(url_for("search.search"))
