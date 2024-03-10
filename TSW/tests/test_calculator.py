import pytest
from code.calculator import Calculator


# Fixtures = imitace reálného zařízení (singleton)
@pytest.fixture
def calculator():
    return Calculator()


@pytest.mark.calculator
def test_last_answer_after_init(calculator):
    assert calculator.ans == 0


@pytest.mark.calculator
@pytest.mark.parametrize(
    "a, b, out",
    [
        (1, 2, 3),
        (-2, -3, -5),
    ],
)
def test_plus(a, b, out, calculator):
    assert calculator.plus(a, b) == out


@pytest.mark.calculator
@pytest.mark.parametrize(
    "a, b, out",
    [
        (1, 1, 0),
        (1, 2, 1),
    ],
)
def test_modulo(a, b, out, calculator):
    assert calculator.modulo(a, b) == out


@pytest.mark.calculator
@pytest.mark.parametrize(
    "a, out",
    [
        (5, 25),
        (2, 4),
        (-4, 16),
    ],
)
def test_caret(a, out, calculator):
    assert calculator.caret(a) == out


@pytest.mark.calculator
def test_delete(calculator):
    calculator.plus(5, 3)
    calculator.delete()
    assert calculator.ans == 0


# TDD
# 1. Napsat předpis funkce
# 2. Napsat test, který má zatím zaručeně selhat (ale pak by měl fungovat)
# 3. Přejdu zpět k funkci a co nejrychleji ji zprovoznit, aby test prošel
