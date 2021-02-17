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

## 연속중복 없애기

배열 arr가 주어집니다. 배열 arr의 각 원소는 숫자 0부터 9까지로 이루어져 있습니다. 이때, 배열 arr에서 연속적으로 나타나는 숫자는 하나만 남기고 전부 제거하려고 합니다. 단, 제거된 후 남은 수들을 반환할 때는 배열 arr의 원소들의 순서를 유지해야 합니다. 예를 들면,

arr = [1, 1, 3, 3, 0, 1, 1] 이면 [1, 3, 0, 1] 을 return 합니다.
arr = [4, 4, 4, 3, 3] 이면 [4, 3] 을 return 합니다.
배열 arr에서 연속적으로 나타나는 숫자는 제거하고 남은 수들을 return 하는 solution 함수를 완성해 주세요.

```
# 완전탐색
def solution(arr):
    result = []
    result.append(arr[0])
    for i in range(1, len(arr)):
        if arr[i] != arr[i-1]:
            result.append(arr[i])


    return result

```

## 약수 구하기

정수 n을 입력받아 n의 약수를 모두 더한 값을 리턴하는 함수, solution을 완성해주세요.

입출력 예 #1
12의 약수는 1, 2, 3, 4, 6, 12입니다. 이를 모두 더하면 28입니다.

입출력 예 #2
5의 약수는 1, 5입니다. 이를 모두 더하면 6입니다.

```
def solution(n):
    result = 0
    for i in range(1, n+1):
        if n % i == 0:
            result += i
    return result

# 반 넘는 값은 계산할 필요 없음
def solution(n):
    sums = n + sum([i for i in range(1, (n // 2) + 1) if n % i == 0])
    return sums
```

## 문자열 내림차순으로 정렬하기

문자열 s에 나타나는 문자를 큰것부터 작은 순으로 정렬해 새로운 문자열을 리턴하는 함수, solution을 완성해주세요.
s는 영문 대소문자로만 구성되어 있으며, 대문자는 소문자보다 작은 것으로 간주합니다.

입출력 예
s = "Zbcdefg"
return = "gfedcbZ"

```
def solution(s):

    return ("".join(sorted(s)[::-1]))
```

## 정수 내림차순으로 정렬하기

함수 solution은 정수 n을 매개변수로 입력받습니다. n의 각 자릿수를 큰것부터 작은 순으로 정렬한 새로운 정수를 리턴해주세요. 예를들어 n이 118372면 873211을 리턴하면 됩니다.

```
def solution(n):
    result = int("".join(sorted(str(n))[::-1]))
    return result

```
