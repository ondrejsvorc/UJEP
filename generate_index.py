import os
import re
from typing import List, Optional

TARGET_FILENAME = "README.md"
OUTPUT_INDEX_FILE = "index.md"
TITLE_HEADER = "## UJEP"
DESCRIPTION = "Automaticky generovaný seznam materiálů z repozitáře."
QUESTION_LABEL = "Otázka"
IGNORE_PREFIX = "."

def natural_sort_key(s):
    return [int(text) if text.isdigit() else text.lower() for text in re.split('([0-9]+)', s)]

def is_hidden(path: str) -> bool:
    return os.path.basename(path).startswith(IGNORE_PREFIX)

def format_url_path(root: str, filename: str) -> str:
    relative_path = os.path.relpath(root, ".")
    url_path = relative_path.replace(" ", "%20")
    return f"{url_path}/"

def get_chapter_display_name(root: str) -> str:
    current_folder = os.path.basename(root)
    
    if not current_folder.isdigit():
        return current_folder

    parent_folder = os.path.basename(os.path.dirname(root))
    return f"{parent_folder} - {QUESTION_LABEL} {current_folder}"

def create_markdown_line(name: str, url: str) -> str:
    return f"- [{name}]({url})"

def build_index_content(links: List[str]) -> str:
    header = f"{TITLE_HEADER}\n\n{DESCRIPTION}\n\n"
    return header + "\n".join(links) + "\n"

def scan_for_markdown_links() -> List[str]:
    markdown_links = []
    all_walk = sorted(os.walk("."), key=lambda x: natural_sort_key(x[0]))

    for root, dirs, files in all_walk:
        dirs[:] = [d for d in dirs if not d.startswith(".")]
        
        if root == "." or TARGET_FILENAME not in files:
            continue
        
        display_name = get_chapter_display_name(root)
        url = format_url_path(root, TARGET_FILENAME)
        markdown_links.append(f"- [{display_name}]({url})")

    return markdown_links

def generate_index() -> None:
    links = scan_for_markdown_links()
    
    if not links:
        print("No content found for generation.")
        return

    content = "---\nlayout: default\ntitle: UJEP Rozcestník\n---\n\n"
    content += f"{TITLE_HEADER}\n\n{DESCRIPTION}\n\n"
    content += "\n".join(links) + "\n"

    with open(OUTPUT_INDEX_FILE, "w", encoding="utf-8") as f:
        f.write(content)

if __name__ == "__main__":
    generate_index()