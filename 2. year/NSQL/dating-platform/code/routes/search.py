import random
from flask import Blueprint, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from app import neo4j
from search_memento import Choice, ChoiceCaretaker
from relationships import DislikeStrategy, LikeStrategy, RelationshipContext
from flask import session

blueprint = Blueprint("search", __name__)


@blueprint.route("/search", methods=["GET"])
@login_required
def search():
    available_matches = neo4j.get_available_matches(current_user.username)
    random_profile = random.choice(available_matches) if available_matches else None

    caretaker = ChoiceCaretaker()
    if "choice_history" in session:
        caretaker_data = session["choice_history"]
        caretaker = ChoiceCaretaker.deserialize_history(caretaker_data)

    return render_template(
        "search.html", profile=random_profile, undo_possible=caretaker.can_undo()
    )


@blueprint.route("/search", methods=["POST"])
@login_required
def search_post():
    friend_name = request.form.get("friend_name")
    choice = request.form.get("date_choice")
    undo = request.form.get("undo")

    user = neo4j.get_user_node(current_user.username)
    friend = neo4j.get_user_node(friend_name)

    caretaker = ChoiceCaretaker()
    if "choice_history" in session:
        caretaker_data = session["choice_history"]
        caretaker = ChoiceCaretaker.deserialize_history(caretaker_data)

    strategy = LikeStrategy() if choice == "like" else DislikeStrategy()
    choice = Choice(strategy)

    if undo and caretaker.can_undo():
        caretaker.undo(choice)
        session["choice_history"] = caretaker.serialize_history()
        return redirect(url_for("search.search"))

    context = RelationshipContext(strategy)
    context.connect(user, friend)

    caretaker.save(choice, friend_name)
    session["choice_history"] = caretaker.serialize_history()

    return redirect(url_for("search.search"))
