def main():
    with open("test.txt") as file:
        content = file.read()

    for line in content.split('\n'):
        step = -1 if line[0] == 'L' else 1


if __name__ == "__main__":
    main()
