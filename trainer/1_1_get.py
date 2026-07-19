import requests

url = "https://www.google.com"
response = requests.get(url)

print(f"Статус код: {response.status_code}")
print(f"Кодировка ответа: {response.encoding}")
print(f"Размера ответа в байтах: {len(response.content)}")

print("Вывод первых 500 символ HTML-содержимого")
print(response.text[:500])
