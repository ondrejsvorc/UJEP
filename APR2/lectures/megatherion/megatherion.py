from abc import abstractmethod, ABC
import csv
from json import load
import math
from numbers import Real
from pathlib import Path
from typing import Dict, Iterable, Iterator, Tuple, Union, Any, List, Callable
from enum import Enum
from collections.abc import MutableSequence


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
        (eg. `Column(["a", "b", "c"]).permute([0,0,2])`
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
        assert 0 <= index < len(self), "Index out of range for the DataFrame."
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
                    if all(
                        value is None or isinstance(float(value), Real) for value in col
                    ):
                        cols[cname].dtype = Type.Float
                except ValueError:
                    # Keep dtype as Type.String
                    pass

        return DataFrame(cols)


if __name__ == "__main__":
    print("Testing reading from CSV:")
    df = DataFrame.read_csv("data.csv")
    print(df)
    print()

    print("Testing reading from JSON:")
    df = DataFrame.read_json("data.json")
    print(df)
    print()

    print("Testing setting a value:")
    df.setvalue("numbers", 0, 42)
    print(df)
    print()

    print("Testing appending a column:")
    new_column_data = [1.5, 2.5, 3]
    new_column = Column(new_column_data, Type.Float)
    df.append_column("new_column", new_column)
    print(df)
    print()

    print("Testing appending a row:")
    new_row = (1, "b", 3, 4)
    df.append_row(new_row)
    print(df)
    print()

    print("Testing filtering:")
    filtered_df = df.filter("numbers", lambda x: x > 1)
    print(filtered_df)
    print()

    print("Testing sorting:")
    df.sort("numbers", ascending=True)
    print(df)
    print()

    print("Testing describing:")
    description = df.describe()
    print(description)
    print()

    print("Testing converting to HTML:")
    html = df.to_html("test.html")
    print(html)

    # print("Testing inner join:")
    # df = DataFrame.read_json("data.json")
    # other_df = DataFrame.read_json("data2.json")
    # joined_df = df.inner_join(other_df, "numbers", "numbers")
    # print(joined_df)
    # print()
