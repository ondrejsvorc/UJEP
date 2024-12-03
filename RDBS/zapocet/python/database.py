from data import Employee, EmployeeEncoder
from dataclasses import dataclass
from typing import List, Type, TypeVar
import psycopg2
import json

T = TypeVar("T")


@dataclass
class DatabaseParams:
    dbname: str
    password: str
    host: str = "localhost"
    user: str = "postgres"
    port: str = "5432"


class Database:
    def __init__(self, params: DatabaseParams):
        self._params = params

    def execute_query(self, query, result_type: Type[T], *args) -> List[T]:
        """
        Execute SQL query and map results to objects of the specified class.

        Args:
            query (str): SQL query to execute.
            result_type (Type[T]): The type to which each row of the query result will be mapped.
            args: Optional query parameters.

        Returns:
            List[T]: List of objects of the specified type.
        """
        with self._connection.cursor() as cursor:
            cursor.execute(query, args)
            results = cursor.fetchall()
        return [result_type(*row) for row in results]

    def get_employees_and_save_to_json(
        database: "Database", query: str, filename: str
    ) -> None:
        result: List[Employee] = database.execute_query(query, Employee)
        with open(filename, "w", encoding="utf-8") as file:
            json.dump(result, file, cls=EmployeeEncoder, ensure_ascii=False, indent=4)

    def __enter__(self):
        self._connection = psycopg2.connect(
            host=self._params.host,
            dbname=self._params.dbname,
            user=self._params.user,
            password=self._params.password,
            port=self._params.port,
        )
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self._connection.close()
