import requests

url = "https://jsonplaceholder.typicode.com/posts"

data = {
    "title": "foo",
    "body": "bar",
    "userId": 1
}

response = requests.post(url, json=data)

print(f"Статус-код: {response.status_code}")
print("Ответа сервера JSON")
print(response.json())  # преобразует ответ в python-словарь/список
