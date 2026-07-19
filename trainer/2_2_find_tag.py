import requests
from bs4 import BeautifulSoup

url = "https://www.python.org"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'lxml')

# Находим первый заголовок h1
h1_tag = soup.find('h1')
if h1_tag:
    print(f"Первый h1: {h1_tag.text}")

# Находим все ссылки
all_links = soup.find_all('a')
print(f"Найдены все ссылки: {len(all_links)}")
for link in all_links:
    print(link.get('href'))  # получаем значение по атрибуту href
