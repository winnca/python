import requests
from bs4 import BeautifulSoup

url = "https://www.python.org"
response = requests.get(url)
response.raise_for_status()

soup = BeautifulSoup(response.text, 'lxml')

print(f"Тип объекта: {type(soup)}")
print("\nЗаголовок страницы: ")
print(soup.title)
print(f"Текст заголовка: {soup.title.string}")
