import httpx
from fastapi import FastAPI, File, UploadFile, Request
from fastapi.responses import JSONResponse
from PIL import Image
from io import BytesIO
import random

app = FastAPI()
available_hosts = set()
timeout = 60*10


@app.post("/receive_image/")
async def receive_image(request: Request, file: UploadFile = File(...)):
    print('RECEIVED')
    contents = await file.read()
    print("Received image size:", len(contents))

    image = Image.open(BytesIO(contents))
    grayscale_image = image.convert("L")
    sender_ip = request.client.host
    available_hosts.add(sender_ip)
    random_ip = random.choice(list(available_hosts))
    async with httpx.AsyncClient(timeout=timeout) as client:
        await client.post(url=f"http://localhost:8000/send_image/", files={"image": contents},
                          params={"endpoint": f"http://{random_ip}:8000/receive_image/"})
    return {"message": "Image received and processed successfully"}


@app.post("/send_image/")
async def send_image(image: UploadFile = File(...), endpoint: str = None):
    print('SENDING')
    print(endpoint)
    image_contents = await image.read()
    print("Sending image size:", len(image_contents))

    if endpoint:
        files = {"file": image_contents}
        async with httpx.AsyncClient(timeout=timeout) as client:
            response = await client.post(url=endpoint, files=files)
            if response.status_code == 200:
                return {"message": "Image sent successfully to the endpoint"}
            else:
                return JSONResponse(status_code=response.status_code,
                                    content={"message": "Failed to send image to the endpoint"})
    else:
        return JSONResponse(status_code=400, content={"message": "Endpoint URL is required"})
