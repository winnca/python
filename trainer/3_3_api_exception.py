import requests
from requests import RequestException
import json


def get_user_data(user_id):
    url_user = f"https://jsonplaceholder.typicode.com/users/{user_id}"
    try:
        response = requests.get(url_user)
        response.raise_for_status()
        return response.json()
    except RequestException as req_err:
        print(f"Ошибка при запросе данных пользователя c id={user_id}")
        if hasattr(req_err, 'response') and req_err.response is not None:
            print(f"Статус-код:{req_err.response.status_code}")
            try:
                error_details = req_err.response.json()
                print(f"Детали ошибки: {error_details}")
            except json.JSONDecodeError:
                print(f"Ошибка парсинга JSON для пользователя {user_id}. Ответ: {req_err.response.text}")
        return None
    except json.JSONDecodeError:
        print(f"Ошибка парсинга пользователя {user_id}")
        return None


user_1 = get_user_data(1)
if user_1:
    print(f"Данные пользователя {user_1}")

user_999 = get_user_data(999)
if user_999 is None:
    print("Данные пользователя не получены")
