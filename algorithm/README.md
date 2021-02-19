# Algorithm Traning

- [Dictionaries-and-Maps]
- [Recursion]

---

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

<!-- 정렬 -->

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

## K번째 수

배열 array의 i번째 숫자부터 j번째 숫자까지 자르고 정렬했을 때, k번째에 있는 수를 구하려 합니다.

예를 들어 array가 [1, 5, 2, 6, 3, 7, 4], i = 2, j = 5, k = 3이라면

array의 2번째부터 5번째까지 자르면 [5, 2, 6, 3]입니다.
1에서 나온 배열을 정렬하면 [2, 3, 5, 6]입니다.
2에서 나온 배열의 3번째 숫자는 5입니다.
배열 array, [i, j, k]를 원소로 가진 2차원 배열 commands가 매개변수로 주어질 때, commands의 모든 원소에 대해 앞서 설명한 연산을 적용했을 때 나온 결과를 배열에 담아 return 하도록 solution 함수를 작성해주세요.

제한사항

- array의 길이는 1 이상 100 이하입니다.
- array의 각 원소는 1 이상 100 이하입니다.
- commands의 길이는 1 이상 50 이하입니다.
- commands의 각 원소는 길이가 3입니다.

```
def solution(array, commands):
    result = []
    for command in commands:
        cutarr = array[command[0]-1:command[1]]
        cutarr.sort()
        result.append(cutarr[command[2]-1])
    return result
```

1. 우선 반복문을 사용해 commands 2차원 배열을 command에 1차원 배열로 따로 저장해줍니다.

2. new_array에 i번째부터 j번째까지 배열을 복사해줍니다.

3. 그 다음 sort()함수를 써서 정렬해줍니다.

4. 이제 k번째 수를 찾아서 answer배열에 저장해줍니다.

## 가장 큰 수

0 또는 양의 정수가 주어졌을 때, 정수를 이어 붙여 만들 수 있는 가장 큰 수를 알아내 주세요.

예를 들어, 주어진 정수가 [6, 10, 2]라면 [6102, 6210, 1062, 1026, 2610, 2106]를 만들 수 있고, 이중 가장 큰 수는 6210입니다.

0 또는 양의 정수가 담긴 배열 numbers가 매개변수로 주어질 때, 순서를 재배치하여 만들 수 있는 가장 큰 수를 문자열로 바꾸어 return 하도록 solution 함수를 작성해주세요.

- numbers의 길이는 1 이상 100,000 이하입니다.
- numbers의 원소는 0 이상 1,000 이하입니다.
- 정답이 너무 클 수 있으니 문자열로 바꾸어 return 합니다.

* int형의 list를 map을 사용하여 string으로 치환한 뒤, list로 변환한다.
* 변환된 num을 sort()를 사용하여 key 조건에 맞게 정렬한다.
* lambda x : x\*3은 num 인자 각각의 문자열을 3번 반복한다는 뜻이다.
* x\*3을 하는 이유? -> num의 인수값이 1000 이하이므로 3자리수로 맞춘 뒤, 비교하겠다는 뜻.
* 문자열 비교는 ASCII 값으로 치환되어 정렬된다. 따라서 666, 101010, 222의 인덱스 값을 차례대로 비교한다.
* 6 = 86, 1 = 81, 2 = 82 이므로 6 > 2 > 1순으로 크다.
* sort()의 기본 정렬 기준은 오름차순이다. reverse = True 전의 sort된 결과값은 10, 2, 6이다.
* 이를 reverse = True를 통해 내림차순 해주면 6,2,10이 된다. 이것을 ''.join(num)을 통해 문자열을 합쳐주면 된다.
* int로 변환한 뒤, 또 str로 변환해주는 이유는 모든 값이 0일 때(즉, '000'을 처리하기 위해) int로 변환한 뒤, 다시 str로 변환한다.

```
def solution(numbers):

    nums = list(map(str, numbers))
    nums.sort(key = lambda x: x*3, reverse = True)

    return str(int("".join(nums)))
```
