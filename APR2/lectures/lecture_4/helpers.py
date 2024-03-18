def get_as_int(s: list, index: int, default=None):
    return int(s[index]) if index < len(s) else default
