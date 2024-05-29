from abc import abstractmethod, ABC
import csv
from json import load
import math
from numbers import Real
from pathlib import Path
from typing import Dict, Iterable, Iterator, Tuple, Union, Any, List, Callable
from enum import Enum
from collections.abc import MutableSequence

# Doimplementováno:
# - permute
# - __getitem__
# - append_row
# - CSVReader.read
# - filter
# - describe
# - sort

# Doimplementováno 2:
# - transpose
# - compare
# - cumsum
# - cumprod
# - diff
# - dot

# - combine

# Přidáno nad rámec:
# to_html

# Vylepšeno:
# to_float

# + různé asserty, vyhazování exception


class Type(Enum):
    Float = 0
    String = 1


def to_float(obj: Any) -> float:
    """
    Casts object to float with support of None objects (None is casted to None).
    float("nan"), float("NaN"), float("NAN   ") should be also all casted to None.
    Raises ValueError if the object cannot be converted to a float.
    """
    return float(obj) if obj is not None and str(obj).strip().lower() != "nan" else None


def to_str(obj: Any) -> str:
    """
    Casts object to string with support of None objects (None is cast to None).
    Raises TypeError if the object cannot be serialized to a string.
    """
    return str(obj) if obj is not None else None


def common(iterable: Iterable) -> Any:
    assert isinstance(
        iterable, Iterable
    ), "iterable must be an instance of collections.abc.Iterable"

    try:
        iterator = iter(iterable)
        first_value = next(iterator)
    except StopIteration:
        raise ValueError("Iterable is empty")
    for value in iterator:
        if value != first_value:
            raise ValueError("Not all values are the same")
    return first_value


def are_common(iterable: Iterable) -> bool:
    """
    Returns True if all items are the same, False otherwise or if iterable is empty.
    """
    assert isinstance(
        iterable, Iterable
    ), "iterable must be an instance of collections.abc.Iterable"

    if not iterable:
        return False
    iterator = iter(iterable)
    first_value = next(iterator)
    return all(value == first_value for value in iterator)


class Column(MutableSequence):
    """
    Representation of column of dataframe. Column has datatype: float columns contains
    only floats and None values, string columns contains strings and None values.
    """

    def __init__(self, data: Iterable, dtype: Type):
        assert isinstance(dtype, Type), "dtype must be a Type"

        self.dtype = dtype
        self._cast = to_float if self.dtype == Type.Float else to_str
        self._data = [self._cast(value) for value in data]

    def append(self, item: Any) -> None:
        """
        Item is appended to column (value is cast to float or string if is not number).
        Implementation of abstract base class `MutableSequence`.
        :param item: appended value
        """
        self._data.append(self._cast(item))

    def insert(self, index: int, value: Any) -> None:
        """
        Item is inserted to colum at index `index` (value is cast to float or string if is not number).
        Implementation of abstract base class `MutableSequence`.
        :param index: index of new item
        :param value: inserted value
        :return:
        """
        if 0 <= index < len(self):
            raise IndexError("Index out of range")
        self._data.insert(index, self._cast(value))

    def permute(self, indices: List[int]) -> "Column":
        """
        Return new column which items are defined by list of indices (to original column).
        (eg. `Column(["a", "b", "c"]).permute([0,0,999])`
        returns  `Column(["a", "a", "c"])
        :param indices: list of indexes (ints between 0 and len(self) - 1)
        :return: new column
        """
        if not all(0 <= i < len(self) for i in indices):
            raise IndexError("One or more indices are out of range")
        permuted_data = [self._data[i] for i in indices]
        return Column(permuted_data, self.dtype)

    def copy(self) -> "Column":
        """
        Return shallow copy of column.
        :return: new column with the same items
        """
        return Column(self._data, self.dtype)

    def _filter_none(self):
        """
        Filter out None and NaN values from the data.
        Null values from JSON and CSV are converted to Python None.
        What can also happen is that someone can pass float("nan") value.
        """
        return [
            value for value in self._data if value is not None and not math.isnan(value)
        ]

    def min(self):
        filtered_data = self._filter_none()
        if not filtered_data:
            raise ValueError(f"No valid data available to compute the minimum.")
        return min(filtered_data)

    def max(self):
        filtered_data = self._filter_none()
        if not filtered_data:
            raise ValueError(f"No valid data available to compute the maximum.")
        return max(filtered_data)

    def mean(self):
        filtered_data = self._filter_none()
        if not filtered_data:
            raise ValueError(f"No valid data available to compute the mean.")
        return sum(filtered_data) / len(self._data)

    def get_formatted_item(self, index: int, *, width: int):
        """
        Auxiliary method for formating column items to string with `width`
        characters. Numbers (floats) are right aligned and strings left aligned.
        Nones are formatted as aligned "n/a".
        :param index: index of item
        :param width:  width
        :return:
        """
        assert width > 0
        if self._data[index] is None:
            if self.dtype == Type.Float:
                return "n/a".rjust(width)
            else:
                return "n/a".ljust(width)
        return format(
            self._data[index],
            f"{width}s" if self.dtype == Type.String else f"-{width}.2g",
        )

    def __getitem__(
        self, item: Union[int, slice]
    ) -> Union[float, str, list[str], list[float]]:
        """
        Indexed getter (get value from index or sliced sublist for slice).
        Implementation of abstract base class `MutableSequence`.
        :param item: index or slice
        :return: item or list of items
        """
        assert isinstance(item, (int, slice)), "item must be an integer or a slice"
        return self._data[item]

    def __setitem__(self, key: Union[int, slice], value: Any) -> None:
        """
        Indexed setter (set value to index, or list to sliced column)
        Implementation of abstract base class `MutableSequence`.
        :param key: index or slice
        :param value: simple value or list of values

        """
        if not isinstance(key, (int, slice)):
            raise TypeError("Key must be an integer or a slice")

        if isinstance(key, int):
            if not (0 <= key < len(self)):
                raise IndexError("Key out of range")

        if isinstance(key, slice):
            if not (0 <= key.start < len(self)):
                raise IndexError("Slice start out of range")
            if not (key.stop <= len(self)):
                raise IndexError("Slice stop out of range")

        self._data[key] = self._cast(value)

    def __delitem__(self, index: Union[int, slice]) -> None:
        """
        Remove item from index `index` or sublist defined by `slice`.
        :param index: index or slice
        """
        if not isinstance(index, (int, slice)):
            raise TypeError("index must be an integer or a slice")

        if isinstance(index, int):
            if not (0 <= index < len(self)):
                raise IndexError("Index out of range")

        if isinstance(index, slice):
            if not (0 <= index.start < len(self)):
                raise IndexError("Slice start out of range")
            if not (index.stop <= len(self)):
                raise IndexError("Slice stop out of range")

        del self._data[index]

    def __len__(self) -> int:
        """
        Implementation of abstract base class `MutableSequence`.
        :return: number of rows
        """
        return len(self._data)


class DataFrame:
    """
    Dataframe with typed and named columns
    """

    def __init__(self, columns: Dict[str, Column]):
        """
        :param columns: columns of dataframe (key: name of dataframe),
                        lengths of all columns has to be the same
        """
        assert len(columns) > 0, "Dataframe without columns is not supported"
        self._size = common(len(column) for column in columns.values())
        self._columns = {name: column.copy() for name, column in columns.items()}

    @property
    def columns(self) -> Iterable[str]:
        """
        :return: names of columns (as iterable object)
        """
        return self._columns.keys()

    def append_column(self, col_name: str, column: Column) -> None:
        """
        Appends new column to dataframe (its name has to be unique).
        :param col_name:  name of new column
        :param column: data of new column
        """
        if col_name in self.columns:
            raise ValueError("Duplicate column name")
        self._columns[col_name] = column.copy()

    def append_row(self, row: Iterable) -> None:
        """
        Appends new row to dataframe.
        :param row: tuple of values for all columns
        """
        assert len(row) == len(
            self._columns
        ), "Row must have the same number of elements as columns."

        for col_name, value in zip(self.columns, row):
            self._columns[col_name].append(value)
        self._size = common(len(column) for column in self._columns.values())

    def transpose(self) -> "DataFrame":
        column_len = len(self)
        # column_len = len(next(iter(self._columns.values())))
        columns_old = self._columns
        columns_new: dict[str, Column] = {}

        # Iterace přes indexy řádků
        for i in range(column_len):
            # Vytvoření nového seznamu hodnot pro nový sloupec, který bude řádkem v původních datech
            new_data = [columns_old[column_name][i] for column_name in columns_old]

            try:
                if all(value is None or float(value) for value in new_data):
                    dtype = Type.Float
            except ValueError:
                dtype = Type.String

            # Vytvoření nového sloupce s transponovanými daty a přidání do slovníku sloupců
            columns_new[f"column{i}"] = Column(new_data, dtype)

        return DataFrame(columns_new)

    def compare(self, other: "DataFrame") -> "DataFrame":
        result_columns = {}

        for name, column in self._columns.items():
            # Kontrola, zda sloupec existuje také v druhém data framu (other)
            if name not in other._columns:
                continue

            diff_values = []
            # Iterace přes všechny hodnoty ve sloupci, dokud jsou hodnoty v obou sloupcích
            for i in range(min(len(column), len(other._columns[name]))):
                # Pokud jsou hodnoty různé, přidáme dvojici (hodnota_self, hodnota_other)
                if column[i] != other._columns[name][i]:
                    diff_values.append((column[i], other._columns[name][i]))

            # Pokud existují rozdíly, přidáme je do výsledného sloupce
            if diff_values:
                result_columns[name] = Column(diff_values, Type.String)

        columns = {name: col for name, col in result_columns.items()}
        return DataFrame(columns)

    def cumsum(self, axis: int = 0) -> "DataFrame":
        columns_new: dict[str, Column] = {}

        is_row_cumsum = axis == 0
        if is_row_cumsum:
            for name, column in self._columns.items():
                cum_sum = 0
                new_column_data = []
                for value in column:
                    if value is None:
                        new_column_data.append(value)
                    else:
                        cum_sum += value
                        new_column_data.append(cum_sum)
                columns_new[name] = Column(new_column_data, column.dtype)
            return DataFrame(columns_new)

        is_column_cumsum = axis == 1
        if is_column_cumsum:
            num_rows = len(self)
            new_rows = []
            for row_index in range(num_rows):
                new_row = []
                cum_sum = 0
                for column in self._columns.values():
                    value = column[row_index]
                    if value is None:
                        new_row.append(value)
                    else:
                        cum_sum += value
                        new_row.append(cum_sum)
                new_rows.append(tuple(new_row))
            columns_new = {
                name: Column([], column.copy().dtype)
                for name, column in self._columns.items()
            }
            df = DataFrame(columns_new)
            for row in new_rows:
                df.append_row(row)
            return df

    def cumprod(self, axis: int = 0) -> "DataFrame":
        columns_new: dict[str, Column] = {}

        is_row_cumprod = axis == 0
        if is_row_cumprod:
            # Iterace přes všechny sloupce
            for name, column in self._columns.items():
                cum_prod = 1
                new_column_data = []
                # Iterace přes všechny hodnoty ve sloupci
                for value in column:
                    if value is None:
                        new_column_data.append(value)
                    else:
                        cum_prod *= value
                        new_column_data.append(cum_prod)
                columns_new[name] = Column(new_column_data, column.dtype)
            return DataFrame(columns_new)

        is_column_cumprod = axis == 1
        if is_column_cumprod:
            num_rows = len(self)
            new_rows = []
            # Iterace přes všechny řádky
            for row_index in range(num_rows):
                new_row = []
                cum_prod = 1
                # Iterace přes všechny sloupce a získání hodnoty pro aktuální řádek
                for column in self._columns.values():
                    value = column[row_index]
                    if value is None:
                        new_row.append(value)
                    else:
                        cum_prod *= value
                        new_row.append(cum_prod)
                new_rows.append(tuple(new_row))
            columns_new = {
                name: Column([], column.copy().dtype)
                for name, column in self._columns.items()
            }
            df = DataFrame(columns_new)
            for row in new_rows:
                df.append_row(row)
            return df

    def diff(self, axis: int = 0) -> "DataFrame":
        # Zjištění počtu řádků a délky řádku (resp. počtu sloupců)
        num_rows = len(self)
        row_len = len(self[0])

        # Rozdíly mezi řádky
        if axis == 0:
            index = 1
            new_rows = []

            # První řádek bude obsahovat hodnoty None, protože nemáme s čím srovnávat
            new_rows.append(tuple(None for _ in range(row_len)))

            # Iterace přes řádky od druhého do posledního
            while index <= num_rows - 1:
                # Výpočet rozdílů mezi aktuálním a předchozím řádkem
                new_row = tuple(x - y for x, y in zip(self[index], self[index - 1]))
                new_rows.append(tuple(new_row))
                index += 1

            # Inicializace nových sloupců s prázdnými daty, ale stejným datovým typem
            columns_new = {
                name: Column([], column.copy().dtype)
                for name, column in self._columns.items()
            }

            df = DataFrame(columns_new)

            # Přidání nových řádků do nového DataFrame
            for row in new_rows:
                df.append_row(row)

            return df

        # Rozdíly mezi sloupci
        if axis == 1:
            new_columns = {}
            first_column_name = next(iter(self._columns.keys()))
            previous_column = None

            for name, column in self._columns.items():
                # První sloupec bude obsahovat hodnoty None, protože nemáme s čím srovnávat
                # Tato podmínka bude pravdivá pouze jednou (prostor pro optimalizaci)
                if previous_column is None:
                    previous_column = column
                    new_columns[first_column_name] = Column(
                        [None] * len(column), column.dtype
                    )
                    continue

                # Výpočet rozdílů mezi aktuálním a předchozím sloupcem
                new_column_data = [x - y for x, y in zip(column, previous_column)]
                new_columns[name] = Column(new_column_data, column.dtype)
                previous_column = column

            return DataFrame(new_columns)

    def dot(self, other: "DataFrame") -> "DataFrame":
        # Počet sloupců v jedné matici musí být roven počtu řádků v druhé matici.
        if len(self._columns) != len(other):
            raise ValueError(
                "Number of columns in self must be the same as number of rows in other"
            )

        column_names = list(other._columns.keys())
        columns = {name: [] for name in column_names}

        # Řádky (self)
        for i in range(len(self)):
            new_row = []

            # Sloupce (other)
            for j in range(len(column_names)):

                # Skalární součin daného řádku a sloupce
                dot_product = sum(
                    self[i][k] * other[k][j] for k in range(len(self._columns))
                )
                new_row.append(dot_product)

            # Přidání hodnot nového řádku do odpovídajících sloupců
            for col_name, value in zip(column_names, new_row):
                columns[col_name].append(value)

        columns = {name: Column(data, Type.Float) for name, data in columns.items()}
        return DataFrame(columns)

    def combine(self, other: "DataFrame", func: callable) -> "DataFrame":
        # Ověření toho, že oba DataFrame mají stejný počet sloupců
        if len(self._columns) != len(other._columns):
            raise ValueError("Both data frames must have the same amount of columns")

        combined_columns = {}

        for name in self._columns:
            # Ověření, že sloupec existuje i v druhém DataFrame
            if name not in other._columns:
                raise ValueError(
                    f"Column {name} was not found in the other data frame."
                )

            # Kombinování dat ze dvou sloupců pomocí poskytnuté funkce
            combined_data = [
                func(self._columns[name][i], other._columns[name][i])
                for i in range(len(self._columns[name]))
            ]
            combined_columns[name] = Column(combined_data, self._columns[name].dtype)

        return DataFrame(combined_columns)

    def groupby(
        self, group_col: str, agg_func: callable = lambda x: sum(x) / len(x)
    ) -> "DataFrame":
        # Ověření, že sloupec pro seskupení existuje
        if group_col not in self._columns:
            raise ValueError(f"Sloupec {group_col} nebyl nalezen v DataFrame")

        grouped_data = {}
        # Iterování přes všechny řádky v DataFrame
        for i in range(len(self._columns[group_col])):
            group_key = self._columns[group_col][i]
            if group_key not in grouped_data:
                grouped_data[group_key] = {
                    col: [] for col in self._columns if col != group_col
                }
            # Přidání hodnoty do příslušné skupiny
            for col in self._columns:
                if col != group_col:
                    grouped_data[group_key][col].append(self._columns[col][i])

        aggregated_data = {group_col: list(grouped_data.keys())}
        # Iterování přes všechny skupiny a aplikace agregační funkce pouze na numerické sloupce
        for group, data in grouped_data.items():
            for col, values in data.items():
                try:
                    # Test, zda je sloupec numerický
                    float(values[0])
                    if col not in aggregated_data:
                        aggregated_data[col] = []
                    aggregated_data[col].append(agg_func(values))
                except ValueError:
                    continue

        # Vytvoření nového DataFrame s agregovanými daty
        columns_new = {
            name: Column(data, Type.Float if name != group_col else Type.String)
            for name, data in aggregated_data.items()
        }
        return DataFrame(columns_new)

    def cummax(self, axis: int = 0) -> "DataFrame":
        columns_new: dict[str, Column] = {}

        if axis == 0:
            # Cumulative max along columns
            for name, column in self._columns.items():
                cum_max = None
                new_column_data = []
                for value in column:
                    if value is None:
                        new_column_data.append(value)
                    else:
                        cum_max = value if cum_max is None else max(cum_max, value)
                        new_column_data.append(cum_max)
                columns_new[name] = Column(new_column_data, column.dtype)
            return DataFrame(columns_new)

        elif axis == 1:
            # Cumulative max along rows
            num_rows = len(next(iter(self._columns.values())))
            new_rows = []
            for row_index in range(num_rows):
                row_values = [column[row_index] for column in self._columns.values()]
                cum_max = None
                new_row = []
                for value in row_values:
                    if value is None:
                        new_row.append(value)
                    else:
                        cum_max = value if cum_max is None else max(cum_max, value)
                        new_row.append(cum_max)
                new_rows.append(new_row)

            # Convert new_rows to new columns format
            for col_index, name in enumerate(self._columns.keys()):
                new_column_data = [row[col_index] for row in new_rows]
                columns_new[name] = Column(new_column_data, self._columns[name].dtype)

            return DataFrame(columns_new)

        else:
            raise ValueError("Axis must be 0 or 1")

    def cummin(self, axis: int = 0) -> "DataFrame":
        columns_new: dict[str, Column] = {}

        if axis == 0:
            # Kumulativní minimum po sloupcích
            for name, column in self._columns.items():
                cum_min = None
                new_column_data = []
                for value in column:
                    if value is None:
                        new_column_data.append(value)
                    else:
                        cum_min = value if cum_min is None else min(cum_min, value)
                        new_column_data.append(cum_min)
                columns_new[name] = Column(new_column_data, column.dtype)
            return DataFrame(columns_new)

        elif axis == 1:
            # Kumulativní minimum po řádcích
            num_rows = len(next(iter(self._columns.values())))
            new_rows = []
            for row_index in range(num_rows):
                row_values = [column[row_index] for column in self._columns.values()]
                cum_min = None
                new_row = []
                for value in row_values:
                    if value is None:
                        new_row.append(value)
                    else:
                        cum_min = value if cum_min is None else min(cum_min, value)
                        new_row.append(cum_min)
                new_rows.append(new_row)

            # Převod new_rows na nový formát sloupců
            for col_index, name in enumerate(self._columns.keys()):
                new_column_data = [row[col_index] for row in new_rows]
                columns_new[name] = Column(new_column_data, self._columns[name].dtype)

            return DataFrame(columns_new)

        else:
            raise ValueError("Osa musí být 0 nebo 1")

    def drop_duplicates(
        self, subset: list[str] = None, keep: str = "first"
    ) -> "DataFrame":
        if subset is None:
            subset = list(self._columns.keys())

        # Validate keep parameter
        if keep not in {"first", "last"}:
            raise ValueError("keep must be either 'first' or 'last'")

        seen = set()
        indices_to_keep = []

        for row_index in range(len(self)):
            row_tuple = tuple(self._columns[col][row_index] for col in subset)
            if row_tuple not in seen:
                seen.add(row_tuple)
                indices_to_keep.append(row_index)
            elif keep == "last":
                if row_tuple in seen:
                    for i, idx in enumerate(indices_to_keep):
                        if (
                            tuple(self._columns[col][idx] for col in subset)
                            == row_tuple
                        ):
                            indices_to_keep.pop(i)
                            break
                    indices_to_keep.append(row_index)

        new_columns = {col: [] for col in list(self._columns.keys())}
        for index in indices_to_keep:
            for col in list(self._columns.keys()):
                new_columns[col].append(self._columns[col][index])

        result_columns = {
            name: Column(data, self._columns[name].dtype)
            for name, data in new_columns.items()
        }
        return DataFrame(result_columns)

    def filter(
        self, col_name: str, predicate: Callable[[Union[float, str]], bool]
    ) -> "DataFrame":
        """
        Returns new dataframe with rows which values in column `col_name` returns
        True in function `predicate`.

        :param col_name: name of tested column
        :param predicate: testing function
        :return: new dataframe
        """
        assert col_name in self.columns, f"Column '{col_name}' not found in DataFrame"

        filtered_columns = {}
        length = 0

        for column_name, column in self._columns.items():
            if column_name == col_name:
                filtered_values = [value for value in column if predicate(value)]
                length = len(filtered_values) if length == 0 else length
            else:
                filtered_values = column[0:length]
            filtered_columns[column_name] = Column(filtered_values, column.dtype)

        return DataFrame(filtered_columns)

    # Tim Sort
    def sort(self, col_name: str, ascending=True) -> None:
        """
        Sort dataframe by column with `col_name` ascending or descending in place.
        :param col_name: name of key column
        :param ascending: direction of sorting
        """
        assert col_name in self.columns, f"Column '{col_name}' not found in DataFrame"

        index_to_sort_by = list(self.columns).index(col_name)
        sorted_rows = sorted(
            zip(*[self._columns[col_name] for col_name in self.columns]),
            key=lambda row: row[index_to_sort_by],
            reverse=not ascending,
        )

        for col_name, sorted_column in zip(self.columns, zip(*sorted_rows)):
            self._columns[col_name] = Column(
                list(sorted_column), self._columns[col_name].dtype
            )

    def describe(self) -> str:
        """
        similar to pandas but only with min, max and avg statistics for floats and count"
        :return: string with formatted decription
        """
        description = ""
        for column_name, column in self._columns.items():
            if column.dtype is Type.Float:
                stats = (
                    f"Count={len(column)}, "
                    f"Mean={column.mean():.2f}, "
                    f"Min={column.min()}, "
                    f"Max={column.max()}, "
                )
                description += f"{column_name}: {stats}\n"
        return description

    def to_html(self, filename: str = None) -> str:
        """
        Convert the DataFrame to an HTML table.

        :param filename: Optional filename to save the HTML content.
        :return: HTML string representing the DataFrame.
        """
        css_classes = """
        <style>
        .dataframe {
            border-collapse: collapse;
        }
        .dataframe th, .dataframe td {
            border: 1px solid black;
            padding: 5px;
        }
        .numeric {
            text-align: right;
        }
        </style>
        """
        html = "<table class='dataframe'>\n"

        html += "<tr>"
        for col_name in self.columns:
            html += f"<th>{col_name}</th>"
        html += "</tr>\n"

        for i in range(len(self)):
            html += "<tr>"
            for col_name, column in self._columns.items():
                cell_class = "numeric" if column.dtype == Type.Float else ""
                if cell_class:
                    html += f"<td class='{cell_class}'>{column[i]}</td>"
                else:
                    html += f"<td>{column[i] if column[i] is not None else 'NaN'}</td>"
            html += "</tr>\n"

        html += "</table>"
        html = f"{css_classes}\n{html}"

        if filename:
            with open(filename, "w") as f:
                f.write(html)

        return html

    def inner_join(
        self, other: "DataFrame", self_key_col: str, other_key_col: str
    ) -> "DataFrame":
        """
        Inner join between self and other dataframe with join predicate
        `self.key_column == other.key_column`.

        Possible collision of column identifiers is resolved by prefixing `_other` to
        columns from `other` data table.
        """
        assert (
            self_key_col in self.columns
        ), f"Column '{self_key_col}' not found in self"
        assert (
            other_key_col in other.columns
        ), f"Column '{other_key_col}' not found in other"

        pass

    def setvalue(self, col_name: str, row_index: int, value: Any) -> None:
        """
        Set new value in dataframe.
        :param col_name: name of columns
        :param row_index: index of row
        :param value: new value (value is cast to type of column)
        :return:
        """
        assert col_name in self.columns, f"Column '{col_name}' not found in DataFrame"
        assert (
            0 <= row_index < len(list(self._columns.values())[0])
        ), f"Row index {row_index} out of bounds"

        col = self._columns[col_name]
        col[row_index] = col._cast(value)

    def __repr__(self) -> str:
        """
        :return: string representation of dataframe (table with aligned columns)
        """
        lines = []
        lines.append(" ".join(f"{name:12s}" for name in self.columns))
        for i in range(len(self)):
            lines.append(
                " ".join(
                    self._columns[cname].get_formatted_item(i, width=12)
                    for cname in self.columns
                )
            )
        return "\n".join(lines)

    def __getitem__(self, index: int) -> Tuple[Union[str, float]]:
        """
        Indexed getter returns row of dataframe as tuple
        :param index: index of row
        :return: tuple of items in row
        """
        assert 0 <= abs(index) < len(self), "Index out of range for the DataFrame."
        return tuple(column[index] for column in self._columns.values())

    def __iter__(self) -> Iterator[Tuple[Union[str, float]]]:
        """
        :return: iterator over rows of dataframe
        """
        for i in range(len(self)):
            yield tuple(c[i] for c in self._columns.values())

    def __len__(self) -> int:
        """
        :return: count of rows
        """
        return self._size

    @staticmethod
    def read_csv(path: Union[str, Path]) -> "DataFrame":
        """
        Read dataframe by CSV reader
        """
        return CsvReader(path).read()

    @staticmethod
    def read_json(path: Union[str, Path]) -> "DataFrame":
        """
        Read dataframe by JSON reader
        """
        return JsonReader(path).read()


class Reader(ABC):
    def __init__(self, path: Union[Path, str]):
        self.path = Path(path)

    @abstractmethod
    def read(self) -> DataFrame:
        raise NotImplemented("Abstract method")


class JsonReader(Reader):
    """
    Factory class for creation of dataframe by JSON file. JSON file must contain
    one object with attributes which array values represents columns.
    The type of columns are inferred from types of their values (columns which
    contains only value is floats columns otherwise string columns),
    """

    def read(self) -> DataFrame:
        with open(self.path, "rt") as f:
            json = load(f)

        columns = {}
        for cname in json.keys():
            dtype = (
                Type.Float
                if all(
                    value is None or isinstance(value, Real) for value in json[cname]
                )
                else Type.String
            )
            columns[cname] = Column(json[cname], dtype)

        return DataFrame(columns)


class CsvReader(Reader):
    """
    Factory class for creation of dataframe by CSV file. CSV file must contain
    header line with names of columns.
    The type of columns should be inferred from types of their values (columns which
    contains only value has to be floats columns otherwise string columns),
    """

    def read(self) -> "DataFrame":
        with open(self.path, mode="rt", encoding="utf-8") as file:
            reader = csv.DictReader(file)
            cols: Dict[str, Column] = {}

            for cname in reader.fieldnames:
                cols[cname] = Column([], Type.String)

            for row in reader:
                for cname, value in row.items():
                    cols[cname].append(value if value != "null" else None)

            for cname, col in cols.items():
                try:
                    if all(value is None or float(value) for value in col):
                        cols[cname].dtype = Type.Float
                except ValueError:
                    # Keep dtype as Type.String
                    pass

        return DataFrame(cols)


if __name__ == "__main__":
    # print("Testing reading from CSV:")
    # df = DataFrame.read_csv("data.csv")
    # print(df)
    # print()

    # print("Testing reading from JSON:")
    # df = DataFrame.read_json("data.json")
    # print(df)
    # print()

    # print("Testing setting a value:")
    # df.setvalue("numbers", 0, 42)
    # print(df)
    # print()

    # print("Testing appending a column:")
    # new_column_data = [1.5, 2.5, 3]
    # new_column = Column(new_column_data, Type.Float)
    # df.append_column("new_column", new_column)
    # print(df)
    # print()

    # print("Testing appending a row:")
    # new_row = (1, "b", 3, 4)
    # df.append_row(new_row)
    # print(df)
    # print()

    # print("Testing filtering:")
    # filtered_df = df.filter("numbers", lambda x: x > 1)
    # print(filtered_df)
    # print()

    # print("Testing sorting:")
    # df.sort("numbers", ascending=True)
    # print(df)
    # print()

    # print("Testing describing:")
    # description = df.describe()
    # print(description)
    # print()

    # print("Testing converting to HTML:")
    # html = df.to_html("test.html")
    # print(html)
    # print()

    # df = DataFrame.read_json("data.json")
    # print(df)
    # transposed_df = df.transpose()
    # print("Testing transpose:")
    # print(transposed_df)
    # print()

    # df1 = DataFrame(
    #     {
    #         "col1": Column([1, 2], Type.Float),
    #         "col2": Column([3, 4], Type.Float),
    #         "col3": Column([5, 6], Type.Float),
    #     }
    # )
    # print(df1)
    # print()

    # df2 = DataFrame(
    #     {
    #         "col1": Column([1, 2], Type.Float),
    #         "col2": Column([3, 4], Type.Float),
    #         "col3": Column([4, 7], Type.Float),
    #     }
    # )
    # print(df2)
    # print()

    # print("Testing compare:")
    # df_comparison = df1.compare(df2)
    # print(df_comparison)
    # print()

    # print("Sample data frame with A and B columns:")
    # df1 = DataFrame(
    #     {
    #         "A": Column([2.0, 3.0, 1.0], Type.Float),
    #         "B": Column([1.0, None, 0.0], Type.Float),
    #     }
    # )
    # print(df1)
    # print()

    # print("DataFrame.cumsum(axis=0)")
    # df_cumsum = df1.cumsum(axis=0)
    # print(df_cumsum)
    # print()

    # print("DataFrame.cumsum(axis=1)")
    # df_cumsum = df1.cumsum(axis=1)
    # print(df_cumsum)
    # print()

    # print("DataFrame.cumprod(axis=0)")
    # df_cumsum = df1.cumprod(axis=0)
    # print(df_cumsum)
    # print()

    # print("DataFrame.cumprod(axis=1)")
    # df_cumsum = df1.cumprod(axis=1)
    # print(df_cumsum)
    # print()

    # print("Sample data frame with a,b,c columns:")
    # df1 = DataFrame(
    #     {
    #         "a": Column([1, 2, 3, 4, 5, 6], Type.Float),
    #         "b": Column([1, 1, 2, 3, 5, 8], Type.Float),
    #         "c": Column([1, 4, 9, 16, 25, 36], Type.Float),
    #     }
    # )
    # print(df1)
    # print()

    # print("DataFrame.diff(axis=0)")
    # diff_df = df1.diff(axis=0)
    # print(diff_df)
    # print()

    # print("DataFrame.diff(axis=1)")
    # diff_df = df1.diff(axis=1)
    # print(diff_df)
    # print()

    # df1 = DataFrame(
    #     {
    #         "a": Column([1, 4], Type.Float),
    #         "b": Column([2, 5], Type.Float),
    #         "c": Column([3, 6], Type.Float),
    #     }
    # )

    # df2 = DataFrame(
    #     {
    #         "a": Column([1, 3, 5], Type.Float),
    #         "b": Column([2, 4, 6], Type.Float),
    #     }
    # )

    # dot_df = df1.dot(df2)
    # print(dot_df)

    # df1 = DataFrame(
    #     {
    #         "a": Column([0, 1, -2, -1], Type.Float),
    #         "b": Column([1, 1, 1, 1], Type.Float),
    #     }
    # )

    # df2 = DataFrame(
    #     {
    #         "a": Column([0, 1], Type.Float),
    #         "b": Column([1, 2], Type.Float),
    #         "c": Column([-1, -1], Type.Float),
    #         "d": Column([2, 0], Type.Float),
    #     }
    # )

    # df1 = DataFrame(
    #     {
    #         "A": Column([0, 0], Type.Float),
    #         "B": Column([4, 4], Type.Float),
    #     }
    # )

    # df2 = DataFrame(
    #     {
    #         "A": Column([1, 1], Type.Float),
    #         "B": Column([3, 3], Type.Float),
    #     }
    # )

    # take_smaller = lambda s1, s2: s1 if s1 + s2 < 7 else s2
    # combined_df = df1.combine(df2, take_smaller)
    # print(combined_df)
    # print()

    # df = DataFrame(
    #     {
    #         "Animal": Column(["Falcon", "Falcon", "Parrot", "Parrot"], Type.String),
    #         "Max Speed": Column([380.0, 370.0, 24.0, 26.0], Type.Float),
    #     }
    # )

    # grouped_df = df.groupby("Animal", agg_func=lambda x: sum(x) / len(x))
    # print(grouped_df)

    # df1 = DataFrame(
    #     {
    #         "A": Column([2.0, 3.0, 1.0], Type.Float),
    #         "B": Column([1.0, None, 0.0], Type.Float),
    #     }
    # )

    # cummax_df0 = df1.cummax(axis=0)
    # print(cummax_df0)
    # print()

    # cummax_df1 = df1.cummax(axis=1)
    # print(cummax_df1)
    # print()

    # df1 = DataFrame(
    #     {
    #         "A": Column([2.0, 3.0, 1.0], Type.Float),
    #         "B": Column([1.0, None, 0.0], Type.Float),
    #     }
    # )

    # cummin_df0 = df1.cummin(axis=0)
    # print(cummin_df0)
    # print()

    # cummin_df1 = df1.cummin(axis=1)
    # print(cummin_df1)
    # print()

    # df = DataFrame(
    #     {
    #         "brand": Column(
    #             ["Yum Yum", "Yum Yum", "Indomie", "Indomie", "Indomie"], Type.String
    #         ),
    #         "style": Column(["cup", "cup", "cup", "pack", "pack"], Type.String),
    #         "rating": Column([4, 4, 3.5, 15, 5], Type.Float),
    #     }
    # )

    # df_dropped = df.drop_duplicates()
    # print(df_dropped)
    # print()

    # df_dropped_subset = df.drop_duplicates(subset=["brand"])
    # print(df_dropped_subset)
    # print()

    # df_dropped_last = df.drop_duplicates(subset=["brand", "style"], keep="last")
    # print(df_dropped_last)
    # print()

    pass
