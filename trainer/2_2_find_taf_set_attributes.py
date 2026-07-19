import requests
from bs4 import BeautifulSoup

url = "https://www.python.org"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'lxml')

# Находим элементы с определённым ID
content_div = soup.find('div', id='content')
if content_div:
    print(f"Найден <div> с id='content': {content_div.text[:50]}")

# Находим все теги <li> (список элементов) с определённым CSS классом 'tier-1 element-1' .
main_nav_items = soup.find_all('li', class_='tier-1 element-1')
print(f"\nНайдено: {len(main_nav_items)} элементов в навигации")
for i, item in enumerate(main_nav_items, 1):
    print(f"--- БЛОК №{i} ---")
    print(item.text.strip())  # Удаляем пробелы и отступы

# Поиск по нескольким атрибутам
python_logo = soup.find('img', src='/static/img/python-logo.png', alt="python™")  # alt = текстовое описание картинки
if python_logo:
    print(f"Найден логотип Python: {python_logo.get('src')}")
