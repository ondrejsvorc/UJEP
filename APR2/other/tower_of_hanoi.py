from typing import List


def move_disk(source_rod: List[int], destination_rod: List[int]) -> None:
    """
    Moves a single disk from the source rod to the destination rod.

    Args:
        source_rod: Rod containing the disk to move.
        destination_rod: Rod where the disk is to be placed.
    """

    if not source_rod:
        raise ValueError("Cannot move a disk from an empty rod!")

    disk = source_rod.pop()
    destination_rod.append(disk)


def tower_of_hanoi(
    disks_to_move: int,
    source_rod: List[int],
    auxiliary_rod: List[int],
    destination_rod: List[int],
) -> None:
    """
    Solves the Tower of Hanoi puzzle using recursion.

    Args:
        disks_to_move: Number of disks to move.
        source_rod: Rod containing the disks initially.
        auxiliary_rod: Rod used as an auxiliary space during the move.
        destination_rod: Rod where all disks should be moved to in the end.
    """

    # Base case: No disks to move, nothing to do.
    if disks_to_move <= 0:
        return

    # Move n - 1 disks from source to auxiliary, using destination as helper.
    tower_of_hanoi(disks_to_move - 1, source_rod, destination_rod, auxiliary_rod)

    # Move the largest disk directly from source to destination.
    move_disk(source_rod, destination_rod)

    # Move n - 1 disks from auxiliary to destination, using source as helper.
    tower_of_hanoi(disks_to_move - 1, auxiliary_rod, source_rod, destination_rod)


def main():
    """
    Initializes the Tower of Hanoi puzzle and prints the solution.
    """

    num_disks = 3
    source_rod = [i for i in range(num_disks, 0, -1)]
    auxiliary_rod = []
    destination_rod = []

    tower_of_hanoi(num_disks, source_rod, auxiliary_rod, destination_rod)

    print(f"Source rod: {source_rod}")
    print(f"Auxiliary rod: {auxiliary_rod}")
    print(f"Destination rod: {destination_rod}")


if __name__ == "__main__":
    main()
