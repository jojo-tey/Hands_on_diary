# filter(function, 반복객체)

# filter() 미사용 코드
def junior(ages):
    result = []
    for age in ages:
        if age <= 19:
            result.append(age)
    return result


def senior(ages):
    result = []
    for age in ages:
        if age >= 19:
            result.append(age)
    return result


age = list(range(1, 40))
print('junior :', junior(age))
print('senior :', senior(age))

# filter() 사용 코드
age = list(range(1, 40))
print('junior :', list(filter(lambda x: x <= 19, age)))
print('senior :', list(filter(lambda x: x >= 20, age)))


# lambda 함수 개념
# x가 들어오면 x에 1을 더한값을 반환해라
# map(), filter(), reduce(), sorted() 등과 같이 씀

# def function_name( 인자 ):
#     return 반환값

# lambda 인자 : 반환값


def function_name(x):
    return x+1


lambda x: x+1

# 함수 호출


def function_name(x):
    return x+1


function_name(10)

(lambda x: x+1)(10)


# 예시 - 짝수만 출력
a, b, c = map(int, input().split())
print(*(lambda a: a % 2 == 0, [a, b, c]))


# *args, **kwargs

# 가변인자를 받을때 앞에 아스테리크를 붙임
# 디폴트값 지정 가능, 생략 가능 예) third = None
# 들어오는 인자의 갯수를 모르거나 들어오는 인자를 모두 받아 처리하고자 할때 사용

# map()맵 함수
