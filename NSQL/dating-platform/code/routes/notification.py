from flask import Blueprint
from flask_mail import Message
from app import mail

blueprint = Blueprint("notification", __name__)


# TODO: Observer Pattern (při match odeslat e-mailovou notifikaci)
@blueprint.route("/notification", methods=["POST"])
def send_notification():
    msg = Message(
        subject="Hello",
        sender="",
        recipients=[""],
    )
    mail.send(msg)
