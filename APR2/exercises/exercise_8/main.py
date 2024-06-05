# Prohledávání grafy
# BFS = prohledávání do šířky (level po levelu)
# DFS = prohledávání do hloubky (co nejvíc v vlevo)

from node import Node
from collections import deque


# Použít frontu
def bfs(root: Node, index: int) -> bool:
    if root is None:
        raise ValueError("Root must be defined.")
    if index < 0:
        raise ValueError("Index must be positive number.")
    if root.data == index:
        return True

    queue = deque([root])
    while queue:
        node = queue.popleft()
        if node.data == index:
            return True
        queue.extend(node.children)
    return False


# Použít zásobník
def dfs(root: Node, index: int) -> bool:
    if root is None:
        raise ValueError("Root must be defined.")
    if index < 0:
        raise ValueError("Index must be positive number.")
    if root.data == index:
        return True

    stack = deque([root])
    while stack:
        node = stack.pop()
        if node.data == index:
            return True
        stack.extend(node.children)
    return False


def create_tree():
    # Level 1
    root = Node(1)

    # Level 2
    node2 = Node(2)
    node3 = Node(3)
    root.add_child(node2)
    root.add_child(node3)

    # Level 3
    node4 = Node(4)
    node5 = Node(5)
    node6 = Node(6)
    node2.add_child(node4)
    node2.add_child(node5)
    node2.add_child(node6)

    node7 = Node(7)
    node3.add_child(node7)

    # Level 4
    node8 = Node(8)
    node9 = Node(9)
    node5.add_child(node8)
    node5.add_child(node9)

    node10 = Node(10)
    node7.add_child(node10)

    # Tree
    return root


if __name__ == "__main__":
    root: Node = create_tree()
    print(root)

    bfs_found: bool = bfs(root, 10)
    bfs_not_found: bool = bfs(root, 11)
    assert bfs_found, "Index should be found"
    assert bfs_not_found is False, "Index shouldn't be found"

    dfs_found: bool = dfs(root, 10)
    dfs_not_found: bool = dfs(root, 11)
    assert dfs_found, "Index should be found"
    assert dfs_not_found is False, "Index shouldn't be found"
