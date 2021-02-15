# Algorithm Traning

- [Dictionaries-and-Maps]
- [Recursion]

## Dictionaries and Maps

- Task
  Given n names and phone numbers, assemble a phone book that maps friends' names to their respective phone numbers. You will then be given an unknown number of names to query your phone book for. For each name queried, print the associated entry from your phone book on a new line in the form name=phoneNumber; if an entry for name is not found, print Not found instead.

> Note: Your phone book should be a Dictionary/Map/HashMap data structure.

```
n = int(input())
name_numbers = [input().split() for _ in range(n)]
phone_book = {k: v for k,v in name_numbers}
while True:
    try:
        name = input()
        if name in phone_book:
            print(f'{name}=' + phone_book[f'{name}'])
        else:
            print('Not found')
    except:
        break+
```

## Recursion

- Task

1. If N <=1, then factorial(N) = 1
2. Otherwise factorial(N) = N \* factorial(N-1)

> Define the factorial function, be sure to use recursion.

```
def factorial(n):
    if n <= 1:
        return 1
    else:
        result = n * factorial(n - 1)
        return result

print(factorial(n))

```
