from typing import Any
from uuid import uuid4


class Node:
    def __init__(self: "Node", data: Any):
        self.id = uuid4()
        self.data = data
        self.children = list["Node"]()
        self._parent = None

    def add_child(self: "Node", child: "Node") -> None:
        child._parent = self
        self.children.append(child)

    def get_height(self) -> int:
        if not self.children:
            return 0
        return 1 + max(child.get_height() for child in self.children)

    def count_leaves(self) -> int:
        if not self.children:
            return 1
        return sum(child.count_leaves() for child in self.children)

    def get_level(self: "Node") -> int:
        level = 0
        parent = self._parent
        while parent:
            level += 1
            parent = parent._parent
        return level

    def __str__(self):
        spaces = " " * self.get_level() * 3
        prefix = spaces + "|__" if self._parent else ""
        result = prefix + str(self.data) + "\n"
        if self.children:
            for child in self.children:
                result += child.__str__()
        return result


def build_product_tree() -> None:
    root = Node("Electronics")

    laptop = Node("Laptop")
    laptop.add_child(Node("Mac"))
    laptop.add_child(Node("Surface"))
    laptop.add_child(Node("Thinkpad"))

    cellphone = Node("Cell Phone")
    cellphone.add_child(Node("iPhone"))
    cellphone.add_child(Node("Google Pixel"))
    cellphone.add_child(Node("Vivo"))

    tv = Node("TV")
    tv.add_child(Node("Samsung"))
    tv.add_child(Node("LG"))

    root.add_child(laptop)
    root.add_child(cellphone)
    root.add_child(tv)

    print(root)
    print("Height of the tree:", root.get_height())
    print("Number of leaves in the tree:", root.count_leaves())


if __name__ == "__main__":
    build_product_tree()
