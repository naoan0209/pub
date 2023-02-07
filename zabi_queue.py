import sys

import requests
from lxml import html

token_url = "http://localhost:8080/api_jsonrpc.php"
queue_url = "http://localhost:8080/queue.php?config=1"
data = {
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {"user": "Admin", "password": "zabbix"},
    "id": 1,
}


response = requests.post(url=token_url, json=data)

cookie = {"zbx_sessionid": response.json()["result"]}

queue_page = requests.get(queue_url, cookies=cookie)


target_proxy = sys.argv[1]
total_queue = 0


html = html.fromstring(queue_page.content)

elements = html.findall('.//table[@class="list-table"]/tbody/tr/td')
for num, element in enumerate(elements):
    if target_proxy in element.text:
        start = num + 1
        end = num + 7
        break

queue_elements = elements[start:end]
for queue in queue_elements:
    total_queue += int(queue.text)

print(total_queue)
