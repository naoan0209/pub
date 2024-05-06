import requests


def get_to_httpbin():
    return requests.get("http://httpbin.org/get")


if __name__ == "__main__":
    print("Hello, Python")

    response = get_to_httpbin()
    print(response)
