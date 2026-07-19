import requests
from requests.exceptions import HTTPError, ConnectionError, RequestException, Timeout

url = "https://nonexisting-domain-12345678.com"

try:
    response = requests.get(url, timeout=5)
    response.raise_for_status()
    print("Запрос успешно выполнен")
except HTTPError as http_err:
    print(f"Ошибка HTTP: {http_err}")
except ConnectionError as conn_err:
    print(f"Ошибка соединения: {conn_err}")
except Timeout as t:
    print(f"Таймаут превышен: {t}")
except RequestException as req_err:
    print(f"Ошибка библиотеки requests: {req_err}")
except Exception as e:
    print(f"Другая ошибка: {e}")
else:
    print(f"Содержимое ответа: {response.text[:10]}") # Выполнится, если в блоке try не выкинуло исключения
    