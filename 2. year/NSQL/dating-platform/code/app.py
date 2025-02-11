from app_builder import AppBuilder
from blueprint_loader import FileBlueprintLoader

app, mail, neo4j, mongo, redis = AppBuilder().build()
FileBlueprintLoader(app).load_blueprints()


@app.login_manager.user_loader
def load_user(user_id):
    return mongo.get_user_by_id(user_id)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
