from dataclasses import dataclass
import json


@dataclass
class Employee:
    id_zamestnanec: int
    nazev_pozice: str
    jmeno: str
    prijmeni: str


class EmployeeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Employee):
            return obj.__dict__
        return super().default(obj)
