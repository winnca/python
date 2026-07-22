import requests
import markdown
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from requests import ConnectionError, HTTPError, RequestException, Timeout

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0"
}

url = "https://aliebraheem-fun.github.io/Modern-Programming-Technologies/"
url_s = urljoin(url, '_sidebar.md')
try:
    response = requests.get(url_s, headers=headers, timeout=5)
    response.raise_for_status()
except HTTPError as http_err:
    print(f"Статус-код HTTP: {http_err}")
except ConnectionError as conn_err:
    print(f"Ошибка соединения: {conn_err}")
except Timeout as t_err:
    print(f"Таймаут истёк: {t_err}")
except RequestException as req_err:
    print(f"Ошибка библиотеки requests: {req_err}")
except Exception as e:
    print(f"Другая ошибка: {e}")
else:
    lxml_parser = markdown.markdown(response.text)
    soup = BeautifulSoup(lxml_parser, 'lxml')

    all_links = soup.find_all('a')
    print(len(all_links))
    for link in all_links:
        if link.get('href')[0:3] == 'pra' or link.get('href')[0] == 'l':
            # file_url = url+link.get('href')
            file_url = urljoin(url, link.get('href'))
            print(file_url)
            try:
                response_file = requests.get(file_url, headers=headers, timeout=5)
                response_file.raise_for_status()
            except HTTPError as http_err:
                print(f"Статус-код HTTP: {http_err}")
            except ConnectionError as conn_err:
                print(f"Ошибка соединения: {conn_err}")
            except Timeout as t_err:
                print(f"Таймаут истёк: {t_err}")
            except RequestException as req_err:
                print(f"Ошибка библиотеки requests: {req_err}")
            except Exception as e:
                print(f"Другая ошибка: {e}")
            else:
                with open(f"{link.get('href')}", "w", encoding='utf-8') as f:
                    f.write(response_file.text)
