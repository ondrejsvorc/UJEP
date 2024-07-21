from pathlib import Path
import time

file_cache = {}
last_update = 0


def get_file_size(home_relpath: str) -> int:
    """
    Returns file size of in bytes.
    :param home_relpath: File path relative to home folder.
    :return: File size in bytes.
    """
    global file_cache
    if home_relpath in file_cache:
        return file_cache[home_relpath].st_size
    home_dir = Path.home()
    file = home_dir / home_relpath
    return file.stat().st_size


def get_file_birth(home_relpath: str) -> int:
    global file_cache
    try:
        if home_relpath in file_cache:
            return file_cache[home_relpath].st_birthtime
        home_dir = Path.home()
        file = home_dir / home_relpath
        return file.stat().st_birthtime
    except AttributeError:
        raise NotImplementedError("st_birthtime is not implemented")


def get_recursive_list_of_files(max_files: int = 1_000_000_000) -> list[str]:
    """
    Returns relative paths to all files in home folder and its subdirectories.
    :return: List of relatives paths.
    """
    # Variable last_update is global, not local, treat it as such.
    global last_update, file_cache
    # If cache doesn't exist or is older than 10 seconds.
    if not file_cache or time.time() - last_update > 10:
        file_cache.clear()
        home_dir = Path.home()
        files_count = 0
        for file in home_dir.glob("**/*"):
            if file.exists():
                rel_path = str(file.relative_to(home_dir))
                file_cache[rel_path] = file.stat()
                files_count += 1
                if files_count == max_files:
                    break
        last_update = time.time()
    return list(file_cache.keys())
