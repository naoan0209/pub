import sys

import requests
from lxml import html

token_url = "http://localhost:8080/api_jsonrpc.php"
queue_url = "http://localhost:8080/queue.php?config=1"

user = "Admin"
password = "zabbix"


def get_cookie(token_url, user, password):
    """[管理>キュー]ページにアクセスするためのcookieを返す"""
    data = {
        "jsonrpc": "2.0",
        "method": "user.login",
        "params": {"user": user, "password": password},
        "id": 1,
    }
    response = requests.post(url=token_url, json=data)
    cookie = {"zbx_sessionid": response.json()["result"]}

    return cookie


def get_queue_page(queue_url, cookie):
    """[管理>キュー]ページのHTMLデータを返す"""
    queue_page = requests.get(url=queue_url, cookies=cookie)
    html_queue_page = html.fromstring(queue_page.content)

    return html_queue_page


def get_queue_count(target_proxy, html_queue_page, queue_count):
    """[管理>キュー]ページ内の情報から指定したプロキシの合計キュー数を返す"""
    elements = html_queue_page.findall('.//table[@class="list-table"]/tbody/tr/td')
    for num, element in enumerate(elements):
        if target_proxy in element.text:
            start = num + 1
            end = num + 7
            break

    queue_elements = elements[start:end]
    for queue in queue_elements:
        queue_count += int(queue.text)

    return queue_count


if __name__ == "__main__":
    # 第1引数にキュー数を取得したいプロキシのホスト名を指定する
    target_proxy = sys.argv[1]
    queue_count = 0

    cookie = get_cookie(token_url=token_url, user=user, password=password)

    html_queue_page = get_queue_page(queue_url=queue_url, cookie=cookie)

    queue_count = get_queue_count(
        target_proxy=target_proxy,
        html_queue_page=html_queue_page,
        queue_count=queue_count,
    )

    print(queue_count)
