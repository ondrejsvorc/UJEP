# 1. Vytvořte Queue třídu, aby měla chování jako fronta za pomocí listu
# Queue() -> queue: konstruktor prázdné fronty
# enqueue(item) -> None: přidá nový prvek do "zadku" fronty
# dequeue() -> item: odebere prvek z "předku" fronty, fronta bude modifikována
# front() -> item: vrátí prvek z předku fronty, ale neodebere prvek (fronta není modifikována)
# rear() -> item: vrátí prvek ze zadku fronty, ale neodebere prvek (fronta není modifikována)
# isEmpty() -> bool: vrací informaci zda je fronta prázdná
# size() -> int: vrací počet prvků ve frontě


class Queue:
    def __init__(self):
        self._innerList = list()

    def enqueue(self, item):
        self._innerList.append(item)

    def enqueueRange(self, items):
        self._innerList.extend(items)

    def dequeue(self):
        if not self.isEmpty():
            self._innerList.pop(0)

    def front(self):
        if not self.isEmpty():
            return self._innerList[0]

    def rear(self):
        if not self.isEmpty():
            return self._innerList[-1]

    def isEmpty(self):
        return self.size() == 0

    def size(self):
        return len(self._innerList)


if __name__ == "__main__":
    queue = Queue()

    queue.enqueue(1)
    assert not queue.isEmpty()
    assert queue.size() == 1
    assert queue.front() == 1
    assert queue.rear() == 1

    queue.enqueueRange([2, 3, 4])
    assert not queue.isEmpty()
    assert queue.size() == 4
    assert queue.front() == 1
    assert queue.rear() == 4

    queue.dequeue()
    assert queue.size() == 3
    assert queue.front() == 2
    assert queue.rear() == 4
