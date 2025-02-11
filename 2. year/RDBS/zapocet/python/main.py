from database import Database, DatabaseParams

if __name__ == "__main__":
    params = DatabaseParams(dbname="Restaurace", password="postgres")

    with Database(params) as database:
        query1 = """SELECT * FROM pivonka.pohled_cisnici"""
        database.get_employees_and_save_to_json(query1, "output/cisnici.json")

        query2 = """SELECT * FROM pivonka.pohled_kuchari"""
        database.get_employees_and_save_to_json(query2, "output/kuchari.json")
