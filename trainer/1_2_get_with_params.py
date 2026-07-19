import requests

url = "https://www.google.com/search"
params = {
    "q": "Python requests library",
    "hl": "ru"  # Язык интерфейса
}

response = requests.get(url, params=params)

print(f"{response.url}")
print(f"{response.status_code}")
print(f"{response.text[:500]}")
