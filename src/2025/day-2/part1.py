def main():
    with open("input.txt") as file:
        content = file.read()

    total = 0

    for numberRange in content.split(","):
        start, end = numberRange.split("-")
        start, end = int(start), int(end)
        for number in range(start, end+1):
            text = str(number)
            text_len = len(text)
            if len(text) % 2 != 0:
                continue
            part1, part2 = text[:text_len//2], text[text_len//2:]
            if part1 == part2:
                total += number

    print(total)

if __name__ == "__main__":
    main()
