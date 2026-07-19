import requests

url = "https://jsonplaceholder.typicode.com/posts"
data = {
    "title": "foo",
    "body": "bar",
    "UserId": 1
}
response = requests.post(url, data=data)

print(f"Статус-код: {response.status_code}")
print(response.json())
