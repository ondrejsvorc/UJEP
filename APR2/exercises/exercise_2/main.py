# Abstraktní datové struktury
# - Sekvenční ADT (u státnic bychom o nich měli umět mluvit, nakreslit obrázek https://www.geeksforgeeks.org/abstract-data-types/)
# https://github.com/pavelberanek91/UJEP/blob/main/APR2/2_sekvencni_struktury.ipynb
# - datové struktury obalené o chování - využívá existující datové struktury
# - queue - FIFO - fronta - front(), rear(), dequeue(), enqueue()
# - stack - LIFO - zásobník - push(), pop()
# - prioritní fronta, ...
# - umět říct nějaké konkrétní use-case

from queue_custom import Queue
from stack_custom import Stack
from brackets import BracketValidator


if __name__ == "__main__":
    queue = Queue()
    stack = Stack()
    validator = BracketValidator()
