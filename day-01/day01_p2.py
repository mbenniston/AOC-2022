

num_top_calorie_elfs = 3
top_calorie_elfs = []


def try_insert_elf_calorie(calorie):
    top_calorie_elfs.append(calorie)
    top_calorie_elfs.sort(reverse=True)

    if len(top_calorie_elfs) > num_top_calorie_elfs:
        top_calorie_elfs.pop()


try:
    current_elf_calorie = 0
    while True:
        line = input()
        if line == "":
            try_insert_elf_calorie(current_elf_calorie)
            current_elf_calorie = 0
        else:
            current_elf_calorie += int(line)
except EOFError:
    pass

print(sum(top_calorie_elfs))
