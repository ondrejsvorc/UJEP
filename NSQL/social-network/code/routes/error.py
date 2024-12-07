from flask import Blueprint, redirect, url_for
from flask_login import current_user

blueprint = Blueprint("error", __name__)


@blueprint.route("/<path:invalid_path>")
def handle_invalid_route(invalid_path):
    if not current_user.is_authenticated:
        return redirect(url_for("auth.login"))
    return redirect(url_for("home.home"))
