from flask import Flask, redirect, render_template, request


app = Flask(__name__)

db = [
    {
        "jmeno": "gulas",
        "ingredience": [
            "Paprika",
            "Brambory",
            "Prase",
        ],
        "postup": "Dám papriku s bramborou a prasetem do hrnce a zamíchám",
    },
    {
        "jmeno": "Rohlík s máslem",
        "ingredience": [
            "Rohlík",
            "Margarín",
            "Příborový nůž",
        ],
        "postup": "Otevřu máslo, vezmu nůž, udělám máz máz na rohlík.",
    },
    {
        "jmeno": "Kebab",
        "ingredience": [
            "Bůh ví",
            "Margarín",
            "Příborový nůž",
        ],
        "postup": "Radši půjdu do kebabárny.",
    },
]


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/recepty")
def recepty():
    return render_template("recepty.html", recepty=db)


@app.route("/recepty/vytvorit", methods=["GET", "POST"])
def recepty_vytvorit():
    if request.method == "GET":
        return render_template("formular.html", recepty=db)
    else:
        jmeno = request.form["jmeno"]
        ingredience = request.form["ingredience"].split("\n")
        postup = request.form["postup"]
        recept = {"jmeno": jmeno, "ingredience": ingredience, "postup": postup}
        db.append(recept)
        return redirect("/recepty")


if __name__ == "__main__":
    app.run(port=8500, debug=True)
