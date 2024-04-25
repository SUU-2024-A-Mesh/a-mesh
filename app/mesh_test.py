import requests

if __name__ == "__main__":
    image_path = "dice-1.png"
    endpoint_url = "http://localhost:8000/send_image/"

    with open(image_path, "rb") as file:
        files = {"image": file}

        response = requests.post(endpoint_url, files=files, params={"endpoint": "http://localhost:8000/receive_image/"})

        print(response.json())
