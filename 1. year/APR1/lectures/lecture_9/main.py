import fast_file_info

print(fast_file_info.get_file_size(".gitconfig"))
print(fast_file_info.get_recursive_list_of_files(max_files=1_000))
print(fast_file_info.get_file_size(".gitconfig"))
print(fast_file_info.get_file_birth(".gitconfig"))
