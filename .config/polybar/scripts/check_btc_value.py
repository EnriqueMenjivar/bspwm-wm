#!/usr/bin/python3

from requests import Session
import json

headers = {
  'Accepts': 'application/json',
}

session = Session()
session.headers.update(headers)
# url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin"
url = "https://data.messari.io/api/v1/assets/btc/metrics"

try:
  response = session.get(url)
  data = json.loads(response.text)
  print(round(data['data']['market_data']['price_usd'],2))
except:
  print('x')

