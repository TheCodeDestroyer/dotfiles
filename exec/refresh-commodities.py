#!/usr/bin/env python

import os
import math
import time
import json
from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects, HTTPError, RequestException
from dotty_dict import dotty
from dotenv import load_dotenv
import yfinance as yf

load_dotenv()

token = os.getenv('NOTION_TOKEN')
database_id = os.getenv('NOTION_COMODITIES_DB')

session = Session()
session.hooks = {
   'response': lambda r, *args, **kwargs: r.raise_for_status()
}

def mapCoinGeckoResultToComodity(result):

	return {
		'id': result.get('id'),
		'name': result.get('name'),
		'symbol': result.get('symbol', '/').upper(),
		'image_url': result.get('image.large'),
		'price': result.get('market_data.current_price.usd'),
	}


def getCrypto(coin_id):
	url = f'https://api.coingecko.com/api/v3/coins/{coin_id}'
	parameters = {
		'localization':'false',
		'tickers':'true',
		'market_data':'true',
		'community_data':'true',
		'developer_data':'true',
		'sparkline':'true'
	}    

	try:
		response = session.get(url, params=parameters)
		result_dict = response.json()
		return dotty(result_dict)
	except RequestException as e:
		print(e.response.text)

def getCryptoNetworkInfo():
	url = f'https://whattomine.com/coins.json'


	try:
		response = session.get(url)
		result_dict = response.json()
		nethash_result = result_dict['coins']

		return dotty(nethash_result)
	except RequestException as e:
		print(e.response.text)


def getNotionData():
  url = f'https://api.notion.com/v1/databases/{database_id}/query'
  headers={
    'Accept': 'application/json',
    'Notion-Version': '2022-06-28',
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {token}',
  }

  try:
    response = session.post(url, headers=headers)
    result_dict = response.json()
    comodity_list_result = result_dict['results']

    return comodity_list_result
  except RequestException as e:
    print(e.response.text)


def updateNotionData(comodity):
	comodityId = comodity.get('id')
	url = f'https://api.notion.com/v1/pages/{comodityId}'
	headers={
	  'Accept': 'application/json',
	  'Notion-Version': '2022-06-28',
	  'Content-Type': 'application/json',
	  'Authorization': f'Bearer {token}',
	}

	try:
		response = session.patch(url, headers=headers,data=comodity.to_json())
	except RequestException as e:
		print(e.response.text)


def getCoin(coin_id):
	rawCoin = getCrypto(coin_id)
	coin = mapCoinGeckoResultToComodity(rawCoin)

	return coin

def getNetworkHash(crypto_network_info, coin_symbol):
	for net_info_tuple in crypto_network_info.items():
		net_info = net_info_tuple[1]

		if net_info.get('tag') == coin_symbol:
			nethash = net_info.get('nethash')
			if isinstance(nethash, int) and nethash > 0:
				return  math.ceil(nethash / 1000000000)
			else:
				return 0


def updateCryptoComodity(comodity, crypto_network_info):
	coin_id = comodity.get('properties.Id.rich_text.0.text.content')

	if coin_id:
		coin = getCoin(coin_id)
		coin_symbol = coin.get('symbol')
		nethash = getNetworkHash(crypto_network_info, coin_symbol)

		del comodity['properties.Updated At']
		comodity['properties.Name.title.0.text.content'] = coin.get('name')
		comodity['properties.Symbol.rich_text.0.text.content'] = coin_symbol
		comodity['properties.Price.number'] = coin.get('price')
		comodity['properties.NetHash.number'] = nethash
		comodity['icon'] = {
			'type': 'external',
			'external': {
			  'url': coin.get('image_url')
			}
		}
		updateNotionData(comodity)
		time.sleep(5)


def updateStockComodity(comodity, symbol):
	stock_raw = yf.Ticker(symbol)
	stock = dotty(stock_raw.info)

	if stock.get('regularMarketPrice'):
		del comodity['properties.Updated At']
		comodity['properties.Name.title.0.text.content'] = stock.get('shortName')
		comodity['properties.Price.number'] = stock.get('regularMarketPrice')
		comodity['icon'] = {
			'type': 'external',
			'external': {
			  'url': stock.get('logo_url')
			}
		}
		updateNotionData(comodity)


def refreshComodities():
	comodity_list = getNotionData()
	crypto_network_info = getCryptoNetworkInfo()

	print('importing data:')
	for comodityRaw in comodity_list:
		comodity = dotty(comodityRaw)
		comodityType = comodity.get('properties.Type.select.name')
		symbol = comodity.get('properties.Symbol.rich_text.0.text.content')

		if comodityType == 'Crypto':
			print(symbol)
			updateCryptoComodity(comodity, crypto_network_info)
		elif comodityType == 'Stock':
			print(symbol)
			updateStockComodity(comodity, symbol)
			
refreshComodities()
