import requests

url_users = "https://jsonplaceholder.typicode.com/users"

# Получение списка всех пользователей
user_response = requests.get(url_users)
user_response.raise_for_status()
users = user_response.json()
print(f"Первые 3 пользователя:\n")
for user in users[:3]:
    print(f"id: {user['id']}, имя: {user['name']}")

# Получение информации о 1-м пользователе
user_url = "https://jsonplaceholder.typicode.com/users/1"
user_response = requests.get(user_url)
user_response.raise_for_status()
user_first = user_response.json()
print(f"\nПервый пользователь: id = {user_first['id']}, name = {user_first['name']}, address-city = {user_first['address']['city']}\n")

