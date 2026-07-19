import requests

url = "https://httpbin.org/headers"
headers = {
    "User-Agent": "MyPythonApp/1.0",
    "Accept-Language": "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
}

response = requests.get(url, headers=headers)

# Заголовки клиента
print(response.status_code)
print(response.json())

# Заголовки сервера
response_head = requests.head(url, headers=headers)
print(response_head.status_code)
print(response_head.headers)
