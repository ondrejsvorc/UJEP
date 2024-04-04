from typing import Any, Iterable
from collections.abc import Collection


class LinkedDeque(Collection):
    def __init__(self, source: Iterable = None):
        self._head = None
        self._tail = None
        self._size = 0

        if source is not None:
            for item in source:
                self.append(item)

    def prepend(self, item: Any):
        self._head = Node(item, self._head)
        if not self:
            self._tail = self._head
        self._size += 1

    def append(self, item: Any):
        original_tail = self._tail
        self._tail = Node(item, None)
        if not self:
            self._head = self._tail
        else:
            original_tail.next = self._tail
        self._size += 1

    def remove_head(self):
        if not self:
            raise ValueError("Empty list.")
        self._head = self._head.next
        self._size -= 1
        if not self:
            assert self._head is None
            self._tail = None

    @property
    def head(self):
        if not self:
            raise ValueError("Empty list.")
        return self._head

    @property
    def headItem(self):
        if not self:
            raise ValueError("Empty list.")
        return self._head.item

    @property
    def tailItem(self):
        if not self:
            raise ValueError("Empty list.")
        return self._tail.item

    def __iter__(self):
        return LinkedDequeIterator(self)
        # node = self._head
        # while node:
        #     yield node.item
        #     node = node.next

    def __bool__(self):
        return bool(self._size)

    def __contains__(self, item):
        node = self._head
        while node:
            if item == node.item:
                return True
            node = node.next
        return False

    def __len__(self):
        return self._size

    def __str__(self):
        result = [f"Len={len(self)}", ":"]
        if not self:
            result.append(f"Head: {self._head}, Tail: {self._tail}")
        else:
            node = self._head
            while node:
                if node == self._head:
                    result.append(f"Head:")
                elif node == self._tail:
                    result.append(f"Tail:")
                result.append(f"{node.item} -> ")
                node = node.next
            result.append("None")
        return "".join(result)


class LinkedDequeIterator:
    def __init__(self, linked_deque: LinkedDeque):
        self._node: Node = linked_deque.head

    def __next__(self):
        if self._node is None:
            raise StopIteration()
        item = self._node.item
        self._node = self._node.next
        return item


class Node:
    def __init__(self, item: Any, next: "Node"):
        self._item = item
        self._next = next

    @property
    def next(self):
        return self._next

    @next.setter
    def next(self, value):
        self._next = value

    @property
    def item(self):
        return self._item


if __name__ == "__main__":
    linked_deque = LinkedDeque([10, 20])
    linked_deque.prepend(2)
    linked_deque.prepend(1)
    linked_deque.append(3)
    linked_deque.append(4)
    print(3 in linked_deque)
    print(6 in linked_deque)
    print(list(linked_deque))
    print(linked_deque)

    linked_deque.remove_head()
    print(list(linked_deque))
    print(linked_deque)

    while linked_deque:
        linked_deque.remove_head()

    print(linked_deque)
