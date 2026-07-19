import requests
from bs4 import BeautifulSoup

url = "https://www.python.org"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'lxml')

# Извлечение текста из заголовка
title_tag = soup.find('title')
if title_tag:
    print(f"Текст заголовка (text): {title_tag.text}")
    print(f"Текст заголовка (string): {title_tag.string}")

# Извлечение атрибута из заголовка
link = soup.find('a')
if link:
    print(f"Первая ссылка: {link.text.strip()}")
    print(f"Атрибут href: {link.get('href')}")
    print(f"Все атрибуты: {link.attrs}")
