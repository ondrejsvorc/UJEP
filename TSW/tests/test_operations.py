import pytest
from code.operations import *


# Test case = testuji různé domény ekvivalence
@pytest.mark.operation
@pytest.mark.parametrize(
    "a, b, out",
    [
        (2, 3, 5),
        (-2, -5, -7),
        (2, -5, -3),
    ],
)
def test_add(a, b, out):
    assert add(a, b) == out


@pytest.mark.operation
@pytest.mark.parametrize(
    "a, out",
    [
        (5, 25),
        (2, 4),
        (-4, 16),
    ],
)
def test_pow(a, out):
    assert pow(a, None) == out


@pytest.mark.operation
def test_div_zerodiverror():
    a, b = 5, 0
    with pytest.raises(ZeroDivisionError) as e:
        div(a, b)
    assert e.type is ZeroDivisionError
