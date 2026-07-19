import requests
from requests.auth import HTTPBasicAuth

url = "https://httpbin.org/basic-auth/user/passwd"

# Метод 1: передача логина и пароля напрямую.
response = requests.get(url, auth=('user', 'passwd'))
print(f"Статус-код с помощью прямой передачи: {response.status_code}")
print(f"Аутентификация успешна: {response.json()['authenticated']}")

# Метод 2: использование объекта HTTPBasicAuth
response = requests.get(url, auth=HTTPBasicAuth('user', 'passwd'))
print(f"Статус-код с помощью BasicAuth: {response.status_code}")
print(f"Аутентификация успешна: {response.json()['authenticated']}")

# Неверные учётные данные
response_fail = requests.get(url, auth=('wrong_user', 'wrong_passwd'))
print(f"Статус-код с неверными данными: {response_fail.status_code}")

