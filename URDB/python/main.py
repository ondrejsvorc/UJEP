from database import Database, DatabaseParams

if __name__ == "__main__":
    password = input("password: ")
    params = DatabaseParams(dbname="restaurace", password=password)

    with Database(params) as database:
        query1 = """SELECT * FROM pivonka.pohled_cisnici"""
        database.execute_query_and_save_to_json(query1, "output/cisnici.json")

        query2 = """SELECT * FROM pivonka.pohled_kuchari"""
        database.execute_query_and_save_to_json(query2, "output/kuchari.json")
