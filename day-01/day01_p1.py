
max_calorie_elf = None

try:
    current_elf_calorie = 0

    while True:
        line = input()
        if line == "":
            if max_calorie_elf is None:
                max_calorie_elf = current_elf_calorie
            else:
                max_calorie_elf = max(current_elf_calorie, max_calorie_elf)
            current_elf_calorie = 0
        else:
            current_elf_calorie += int(line)
except EOFError:
    pass

print(max_calorie_elf)
