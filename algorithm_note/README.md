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

## 나누어 떨어지는 숫자 배열

array의 각 element 중 divisor로 나누어 떨어지는 값을 오름차순으로 정렬한 배열을 반환하는 함수, solution을 작성해주세요.
divisor로 나누어 떨어지는 element가 하나도 없다면 배열에 -1을 담아 반환하세요.

- arr은 자연수를 담은 배열입니다.
- 정수 i, j에 대해 i ≠ j 이면 arr[i] ≠ arr[j] 입니다.
- divisor는 자연수입니다.
- array는 길이 1 이상인 배열입니다.

```
1.
def solution(arr, divisor):
    arr = sorted([x for x in arr if x % divisor == 0]);
    return arr if len(arr) != 0 else [-1];



22.
def solution(arr, divisor): return sorted([n for n in arr if n%divisor == 0]) or [-1]
```

## 가장 작은 수 제거하기

정수를 저장한 배열, arr 에서 가장 작은 수를 제거한 배열을 리턴하는 함수, solution을 완성해주세요. 단, 리턴하려는 배열이 빈 배열인 경우엔 배열에 -1을 채워 리턴하세요. 예를들어 arr이 [4,3,2,1]인 경우는 [4,3,2]를 리턴 하고, [10]면 [-1]을 리턴 합니다.

- arr은 길이 1 이상인 배열입니다.
- 인덱스 i, j에 대해 i ≠ j이면 arr[i] ≠ arr[j] 입니다.

```
1.
def solution(arr):

    if len(arr) > 1:
        arr.remove(min(arr))
        return arr
    else:
        return [-1]


2.
def rm_small(mylist):
    return [i for i in mylist if i > min(mylist)]
```

## 자릿수 더하기

자연수 N이 주어지면, N의 각 자릿수의 합을 구해서 return 하는 solution 함수를 만들어 주세요.
예를들어 N = 123이면 1 + 2 + 3 = 6을 return 하면 됩니다.

```
1.
def solution(n):
    answer = 0
    for i in str(n):
        answer += int(i)
    return answer

2.
def sum_digit(number):
    return sum(map(int, str(number)))
```

## 두개 뽑아서 더하기

정수 배열 numbers가 주어집니다. numbers에서 서로 다른 인덱스에 있는 두 개의 수를 뽑아 더해서 만들 수 있는 모든 수를 배열에 오름차순으로 담아 return 하도록 solution 함수를 완성해주세요.

- 입출력 예 

numbers|result
--------|--------
[2,1,3,4,1]|[2,3,4,5,6,7]
[5,0,2,7]|[2,5,7,9,12]


- 중복제거를 위해 set() 사용 후 list로 리턴
- 반복문을 통해 결과값을 add

```py
def solution(numbers):
    answer = set()
    
    for i in range(len(numbers)):
        for j in range(i+1, len(numbers)):
            answer.add(numbers[i] + numbers[j])
    result = list(answer)
    result.sort()
    return result
```


## 완주하지 못한 선수(해시)



수많은 마라톤 선수들이 마라톤에 참여하였습니다. 단 한 명의 선수를 제외하고는 모든 선수가 마라톤을 완주하였습니다.

마라톤에 참여한 선수들의 이름이 담긴 배열 participant와 완주한 선수들의 이름이 담긴 배열 completion이 주어질 때, 완주하지 못한 선수의 이름을 return 하도록 solution 함수를 작성해주세요.


- 입출력 예

participant | completion | return
-----|-----|-----
["leo", "kiki", "eden"]	| ["eden", "kiki"] | "leo"
["marina", "josipa", "nikola", "vinko", "filipa"] | ["josipa", "filipa", "marina", "nikola"] | "vinko"
["mislav", "stanko", "mislav", "ana"] | ["stanko", "ana", "mislav"] | "mislav"


- 정렬 후 zip함수를 써서 비교
- 중복되지 않은 하나(완주하지 못한 선수)를 반환

또는

- collections.Counter()는 리스트 원소의 갯수를 세서 dict 형태로 반환해준다. 
- Counter 객체 끼리는 차집합 교집합 등 연산도 가능하다.



```py
def solution(participant, completion):
    
    participant.sort()
    completion.sort()
    
    for k, v in zip(participant, completion):
        if k != v:
            return k
        
    return participant[-1]

########

import collections
 
 
def solution(participant, completion):
    answer = collections.Counter(participant) - collections.Counter(completion)
    return list(answer.keys())[0]

```



## 신규아이디 추천

카카오에 입사한 신입 개발자 네오는 "카카오계정개발팀"에 배치되어, 카카오 서비스에 가입하는 유저들의 아이디를 생성하는 업무를 담당하게 되었습니다. "네오"에게 주어진 첫 업무는 새로 가입하는 유저들이 카카오 아이디 규칙에 맞지 않는 아이디를 입력했을 때, 입력된 아이디와 유사하면서 규칙에 맞는 아이디를 추천해주는 프로그램을 개발하는 것입니다.
다음은 카카오 아이디의 규칙입니다.

아이디의 길이는 3자 이상 15자 이하여야 합니다.
아이디는 알파벳 소문자, 숫자, 빼기(-), 밑줄(_), 마침표(.) 문자만 사용할 수 있습니다.
단, 마침표(.)는 처음과 끝에 사용할 수 없으며 또한 연속으로 사용할 수 없습니다.
"네오"는 다음과 같이 7단계의 순차적인 처리 과정을 통해 신규 유저가 입력한 아이디가 카카오 아이디 규칙에 맞는 지 검사하고 규칙에 맞지 않은 경우 규칙에 맞는 새로운 아이디를 추천해 주려고 합니다.
신규 유저가 입력한 아이디가 new_id 라고 한다면,

```
1단계 new_id의 모든 대문자를 대응되는 소문자로 치환합니다.
2단계 new_id에서 알파벳 소문자, 숫자, 빼기(-), 밑줄(_), 마침표(.)를 제외한 모든 문자를 제거합니다.
3단계 new_id에서 마침표(.)가 2번 이상 연속된 부분을 하나의 마침표(.)로 치환합니다.
4단계 new_id에서 마침표(.)가 처음이나 끝에 위치한다면 제거합니다.
5단계 new_id가 빈 문자열이라면, new_id에 "a"를 대입합니다.
6단계 new_id의 길이가 16자 이상이면, new_id의 첫 15개의 문자를 제외한 나머지 문자들을 모두 제거합니다.
     만약 제거 후 마침표(.)가 new_id의 끝에 위치한다면 끝에 위치한 마침표(.) 문자를 제거합니다.
7단계 new_id의 길이가 2자 이하라면, new_id의 마지막 문자를 new_id의 길이가 3이 될 때까지 반복해서 끝에 붙입니다.
```

- 차례대로 조건에 맞게 잘라줌

```py
def solution(new_id):
    answer = ''
    
    #1
    new_id = new_id.lower()
    
    #2
    for word in new_id:
        if word.isalnum() or word in '-_.' :
            answer += word
    
    #3
    while '..' in answer:
        answer = answer.replace('..', '.')
    
    #4
    answer = answer[1:] if answer[0] == '.' and len(answer) > 1 else answer
    answer = answer[:-1] if answer[-1] == '.' else answer
    
    #5
    answer = 'a' if answer == '' else answer
    
    #6 
    if len(answer) >= 16:
        answer = answer[:15]
        if answer[-1] == '.':
            answer = answer[:-1]
    
    #7 
    if len(answer) <= 3:
        answer = answer + answer[-1] * (3-len(answer))
    return answer


# 라이브러리 & 정규표현식 이용

import re

def solution(new_id):
    answer = ''
    # 1단계 & 2단계 : 소문자 치환
    answer = re.sub('[^a-z\d\-\_\.]', '', new_id.lower())
    # 3단계 : 마침표 2번 이상 > 하나로
    answer = re.sub('\.\.+', '.', answer)
    # 4단계 : 양 끝 마침표 제거
    answer = re.sub('^\.|\.$', '', answer)
    # 5단계 : 빈 문자열이면 a 대입
    if answer == '':
        answer = 'a'
    # 6단계 : 길이가 16자 이상이면 1~15자만 남기기 & 맨 끝 마침표 제거
    answer = re.sub('\.$', '', answer[0:15])
    # 7단계 : 길이가 3이 될 때까지 반복해서 끝에 붙이기
    while len(answer) < 3:
        answer += answer[-1:]
    return answer


```


## 모의고사 (완전탐색)



