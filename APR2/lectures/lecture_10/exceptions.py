class SpecificError(Exception):
    pass


def f():
    try:
        g()
    except SpecificError as e:
        raise Exception("Internal error") from e


def g():
    raise SpecificError("Specific error")


if __name__ == "__main__":
    try:
        f()
    except Exception as e:
        while e.__cause__ is not None:
            print(f"{str(e)} from error {e.__cause__}")
            e = e.__cause__
