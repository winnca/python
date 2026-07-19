import requests
from requests import ConnectionError, HTTPError, RequestException, Timeout

headers = {
    "Accept": "application/json",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0"
}
params_moscow = {
    "latitude": 55.7539,  # широта
    "longitude": 37.6203,  # долгота
    "past_days": 7,  # прошедшие дни
    "forecast_days": 7,  # следующие прогнозируемые дни
    "daily": "temperature_2m_mean,apparent_temperature_mean,precipitation_probability_mean,wind_speed_10m_max,sunrise,sunset,weather_code",  # Ежедневные данные
    "timezone": "auto",  # API сам определяет время по координатам
    "current": "temperature_2m,apparent_temperature"  # температура воздуха на высоте 2 м от земли, ощущаемая температура
}
url = "https://api.open-meteo.com/v1/forecast"
wmo = {
    0: "Ясное небо",
    1: "Преимущественно ясно",
    2: "Переменная облачность",
    3: "Пасмурно",
    45: "Туман",
    48: "Осаждающий изморосью туман",
    51: "Морось лёгкая",
    53: "Морось умеренная",
    55: "Морось плотная",
    56: "Замерзающая лёгкая морось",
    57: "Замерзающая плотная морось",
    61: "Дождь слабый",
    63: "Дождь умеренный",
    65: "Дождь сильный",
    66: "Ледяной дождь слабый",
    67: "Ледяной дождь сильный",
    71: "Снегопад слабый",
    73: "Снегопад умеренный",
    75: "Снегопад сильный",
    77: "Снежные зёрна",
    80: "Ливневый дождь слабый",
    81: "Ливневый дождь умеренный",
    82: "Ливневый дождь шквалистый",
    85: "Ливневый снегопад слабый",
    86: "Ливневый снегопад сильный",
    95: "Гроза",
    96: "Гроза со слабым градом",
    99: "Гроза с сильным ветром"
}

try:
    response = requests.get(url, headers=headers, params=params_moscow, timeout=5)
    response.raise_for_status()
except ConnectionError as conn_err:
    print(f"Ошибка соединения: {conn_err}")
except HTTPError as http_err:
    print(f"Статус-код ошибки: {http_err}")
except RequestException as req_err:
    print(f"Ошибка библиотеки: {req_err}")
except Timeout as t_err:
    print(f"Таймаут превышен {t_err}")
except Exception as e:
    print(f"Другая ошибка: {e}")
else:
    answer = response.json()

    current = answer['current']
    print(f"\nТекущая погода: {current['temperature_2m']}{answer['current_units']['temperature_2m']}")
    print(f"Ощущаемая погода: {current['apparent_temperature']}{answer['current_units']['apparent_temperature']}\n")

    daily = answer['daily']
    for i in range(len(daily['time'])):
        print(f"{i+1}. Дата: {daily['time'][i]}, средняя температура: {daily['temperature_2m_mean'][i]}{answer['daily_units']['temperature_2m_mean']}, ощущаемая температура средняя: {daily['apparent_temperature_mean'][i]}{answer['daily_units']['apparent_temperature_mean']}.")
        print(f"Средняя вероятность выпадения осадков: {daily['precipitation_probability_mean'][i]}{answer['daily_units']['precipitation_probability_mean']}.")
        print(f"Скорость ветра: макс. = {daily['wind_speed_10m_max'][i]}{answer['daily_units']['wind_speed_10m_max']}.")
        print(f"Восход в {daily['sunrise'][i].split('T')[-1]}, закат в {daily['sunset'][i].split('T')[-1]}.")
        print(f"Погода: {wmo.get(daily['weather_code'][i], 'Unknown weather')}.\n")
