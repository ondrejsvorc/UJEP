
<?
declare(strict_types=1);
namespace App\Services;

class PopularDish {
    public string $dishName;
    public int $orderCount;
}

class PositionHierarchy {
    public int $positionId;
    public string $positionName;
    public ?string $supervisorName;
}

class EmployeeHierarchy {
    public int $employeeId;
    public string $employeeName;
    public int $positionId;
    public string $positionName;
    public ?int $supervisorPositionId;
    public ?string $supervisorName;
}

class PopularDishByDate {
    public string $dishName;
    public string $orderDate;
    public int $orderCount;
}

class TopSpendingCustomer {
    public string $firstName;
    public string $lastName;
    public float $totalSpent;
}

class ProductiveEmployee {
    public string $firstName;
    public string $lastName;
    public string $positionName;
    public int $orderCount;
}

class ProductiveEmployeeByDate {
    public string $firstName;
    public string $lastName;
    public string $positionName;
    public string $orderDate;
    public int $orderCount;
}

class ReportService {
    private \PDO $pdo;

    public function __construct(\PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getPopularDishes(): array {
        $sql = '
            SELECT
                PolozkyMenu.Nazev AS "dishName",
                COUNT(*) AS "orderCount"
            FROM
                Pivonka.PolozkyObjednavek AS PolozkyObjednavek
            INNER JOIN
                Pivonka.PolozkyMenu AS PolozkyMenu
                  ON PolozkyObjednavek.Id_PolozkaMenu = PolozkyMenu.Id_PolozkaMenu
            GROUP BY
                PolozkyMenu.Nazev
            ORDER BY
                "orderCount" DESC;
        ';
        return $this->pdo->query($sql)->fetchAll(\PDO::FETCH_CLASS, 'PopularDish');
    }

    public function getPositionHierarchy(): array {
        $sql = '
            WITH RECURSIVE PositionCTE AS (
                SELECT
                    Id_Pozice,
                    Nazev AS "positionName",
                    NULL::VARCHAR AS "supervisorName"
                FROM
                    Pivonka.Pozice
                WHERE
                    Id_PoziceNadrizeny IS NULL
                UNION ALL
                SELECT
                    p.Id_Pozice,
                    p.Nazev AS "positionName",
                    cte."positionName" AS "supervisorName"
                FROM
                    Pivonka.Pozice p
                JOIN
                    PositionCTE cte ON p.Id_PoziceNadrizeny = cte.Id_Pozice
            )
            SELECT
                Id_Pozice AS "positionId",
                "positionName",
                "supervisorName"
            FROM
                PositionCTE
            ORDER BY
                "positionId";
        ';
        return $this->pdo->query($sql)->fetchAll(\PDO::FETCH_CLASS, 'PositionHierarchy');
    }

    public function getEmployeeHierarchy(): array {
        $sql = '
            WITH RECURSIVE position_hierarchy AS (
                SELECT
                    z.Id_Zamestnanec AS "employeeId",
                    z.Jmeno || \' \' || z.Prijmeni AS "employeeName",
                    p.Id_Pozice AS "positionId",
                    p.Nazev AS "positionName",
                    p.Id_PoziceNadrizeny AS "supervisorPositionId",
                    CASE
                        WHEN p.Id_PoziceNadrizeny IS NULL THEN NULL
                        ELSE n.Jmeno || \' \' || n.Prijmeni
                    END AS "supervisorName"
                FROM
                    Pivonka.Zamestnanci z
                JOIN
                    Pivonka.Pozice p ON z.Id_Pozice = p.Id_Pozice
                LEFT JOIN
                    Pivonka.Zamestnanci n ON p.Id_PoziceNadrizeny = n.Id_Pozice
            ),
            recursive_hierarchy AS (
                SELECT
                    "employeeId", "employeeName", "positionId", "positionName", "supervisorPositionId", "supervisorName"
                FROM
                    position_hierarchy
                WHERE
                    "supervisorPositionId" IS NULL
                UNION ALL
                SELECT
                    ph."employeeId", ph."employeeName", ph."positionId", ph."positionName", ph."supervisorPositionId", ph."supervisorName"
                FROM
                    position_hierarchy ph
                INNER JOIN
                    recursive_hierarchy rh ON ph."supervisorPositionId" = rh."positionId"
            )
            SELECT DISTINCT *
            FROM recursive_hierarchy
            ORDER BY "positionId";
        ';
        return $this->pdo->query($sql)->fetchAll(\PDO::FETCH_CLASS, 'EmployeeHierarchy');
    }

    public function getPopularDishesByOrderDate(): array {
        $sql = '
            SELECT
                PolozkyMenu.Nazev AS "dishName",
                DATE(Objednavky.Datum) AS "orderDate",
                COUNT(*) AS "orderCount"
            FROM
                Pivonka.Objednavky AS Objednavky
            INNER JOIN
                Pivonka.PolozkyObjednavek AS PolozkyObjednavek
                  ON Objednavky.Id_Objednavka = PolozkyObjednavek.Id_Objednavka
            INNER JOIN
                Pivonka.PolozkyMenu AS PolozkyMenu
                  ON PolozkyObjednavek.Id_PolozkaMenu = PolozkyMenu.Id_PolozkaMenu
            GROUP BY
                PolozkyMenu.Nazev,
                DATE(Objednavky.Datum)
            ORDER BY
                "orderDate" DESC,
                "orderCount" DESC;
        ';
        return $this->pdo->query($sql)->fetchAll(\PDO::FETCH_CLASS, 'PopularDishByDate');
    }

    public function getTopSpendingCustomers(): array {
        $sql = '
            SELECT
                Zakaznici.Jmeno AS "firstName",
                Zakaznici.Prijmeni AS "lastName",
                SUM(PolozkyMenu.Cena * PolozkyObjednavek.Mnozstvi) AS "totalSpent"
            FROM
                Pivonka.Zakaznici AS Zakaznici
            LEFT JOIN
                Pivonka.Rezervace AS Rezervace ON Zakaznici.Id_Zakaznik = Rezervace.Id_Zakaznik
            LEFT JOIN
                Pivonka.Objednavky AS Objednavky ON Rezervace.Id_Rezervace = Objednavky.Id_Rezervace
            LEFT JOIN
                Pivonka.PolozkyObjednavek AS PolozkyObjednavek ON Objednavky.Id_Objednavka = PolozkyObjednavek.Id_Objednavka
            LEFT JOIN
                Pivonka.PolozkyMenu AS PolozkyMenu ON PolozkyObjednavek.Id_PolozkaMenu = PolozkyMenu.Id_PolozkaMenu
            GROUP BY
                Zakaznici.Jmeno,
                Zakaznici.Prijmeni
            ORDER BY
                "totalSpent" DESC;
        ';
        return $this->pdo->query($sql)->fetchAll(\PDO::FETCH_CLASS, 'TopSpendingCustomer');
    }

    public function getProductiveEmployees(): array {
        $sql = '
            SELECT
                Zamestnanci.Jmeno AS "firstName",
                Zamestnanci.Prijmeni AS "lastName",
                Pozice.Nazev AS "positionName",
                COUNT(*) AS "orderCount"
            FROM
                Pivonka.Zamestnanci AS Zamestnanci
            INNER JOIN
                Pivonka.Objednavky AS Objednavky
                    ON (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecCisnik)
                    OR (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecKuchar)
            INNER JOIN
                Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
            GROUP BY
                Zamestnanci.Jmeno,
                Zamestnanci.Prijmeni,
                Pozice.Nazev
            ORDER BY
                "orderCount" DESC;
        ';
        return $this->pdo->query($sql)->fetchAll(\PDO::FETCH_CLASS, 'ProductiveEmployee');
    }

    public function getProductiveEmployeesByDate(): array {
        $sql = '
            SELECT
                Zamestnanci.Jmeno AS "firstName",
                Zamestnanci.Prijmeni AS "lastName",
                Pozice.Nazev AS "positionName",
                Objednavky.Datum::DATE AS "orderDate",
                COUNT(*) AS "orderCount"
            FROM
                Pivonka.Zamestnanci AS Zamestnanci
            INNER JOIN
                Pivonka.Objednavky AS Objednavky
                    ON (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecCisnik)
                    OR (Zamestnanci.Id_Zamestnanec = Objednavky.Id_ZamestnanecKuchar)
            INNER JOIN
                Pivonka.Pozice AS Pozice ON Zamestnanci.Id_Pozice = Pozice.Id_Pozice
            GROUP BY
                Zamestnanci.Jmeno,
                Zamestnanci.Prijmeni,
                Pozice.Nazev,
                Objednavky.Datum::DATE
            ORDER BY
                "orderCount" DESC,
                "orderDate" DESC;
        ';
        return $this->pdo->query($sql)->fetchAll(\PDO::FETCH_CLASS, 'ProductiveEmployeeByDate');
    }
}
