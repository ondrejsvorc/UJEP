# 2. Vytvořte Stack třídu, aby měla chování jako zásobník za pomocí listu
# Stack() -> stack: konstruktor prázdného zásobníku
# push(item) -> None: přidá nový prvek na vrchol zásobníku
# pop() -> item: odebere prvek z vrcholu zásobníku
# peek() -> item: vrátí prvek z vrcholu zásobníku, ale neodstraní ho
# isEmpty() -> bool: vrací informaci, zda je zásobník prázdný
# size() -> int: vrací počet prvků v zásobníku


class Stack:
    def __init__(self):
        self._innerList = list()

    def push(self, item):
        self._innerList.append(item)

    def pushRange(self, items):
        self._innerList.extend(items)

    def pop(self):
        if not self.isEmpty():
            return self._innerList.pop()

    def peek(self):
        if not self.isEmpty():
            return self._innerList[-1]

    def isEmpty(self):
        return self.size() == 0

    def size(self):
        return len(self._innerList)


if __name__ == "__main__":
    stack = Stack()

    stack.push(5)
    assert not stack.isEmpty()
    assert stack.size() == 1
    assert stack.peek() == 5

    stack.pushRange([6, 7, 8])
    assert not stack.isEmpty()
    assert stack.size() == 4
    assert stack.peek() == 8

    stack.pop()
    assert not stack.isEmpty()
    assert stack.size() == 3
    assert stack.peek() == 7

    stack.pop()
    assert not stack.isEmpty()
    assert stack.size() == 2
    assert stack.peek() == 6
