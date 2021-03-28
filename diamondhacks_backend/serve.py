from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import numpy as np
import classes
from sentence_transformers import SentenceTransformer
import uvicorn
from semantic_text_similarity.models import WebBertSimilarity
from worker.celery_worker import generate_questions
from celery_app import celery_app
from celery.result import AsyncResult
from uuid import uuid4
import json
global web_model
web_model = WebBertSimilarity(device='cpu', batch_size=10)
global clients

clients = dict()
global model
model = SentenceTransformer('bert-base-nli-mean-tokens')
app = FastAPI(title="StudyBuddy",
              version="1.0")


def cosine(u, v):
    return np.dot(u, v) / (np.linalg.norm(u) * np.linalg.norm(v))


@app.websocket("/ws/client")
async def websocket_client(websocket: WebSocket):
    global clients
    await websocket.accept()
    pending_jobs = False
    client_id = ""
    try:
        while True:
            data = await websocket.receive_text()
            data = data.split("||||")
            print(data)
            if data[0] == "CREATE_CLIENT_ID":
                client_id = str(uuid4())
                clients[client_id] = {"jobs": []}
                await websocket.send_text(f"RETURN_CLIENT_ID||||{client_id}")
            if data[0] == "SET_CLIENT_ID":
                client_id = str(data[1])
                try:
                    if len(clients[client_id]["jobs"]) != 0:
                        pending_jobs = True
                except KeyError:
                    clients[client_id] = {"jobs": []}
                    pending_jobs = False

            if data[0] == "CREATE_JOB":
                task_id = str(uuid4())
                generate_questions.apply_async(kwargs={"url": data[1]}, task_id=task_id)
                clients[client_id]["jobs"].append(task_id)
                pending_jobs = True

            print(pending_jobs)
            if pending_jobs:
                uid = clients[client_id]["jobs"][-1]
                job = celery_app.AsyncResult(uid)
                if job.status == "SUCCESS":
                    print("SUCCESS")
                    result = AsyncResult(job.id, app=celery_app)
                    results = result.get()
                    results["client_id"] = client_id
                    results = json.dumps(results)
                    print(results)
                    print(type(results))
                    await websocket.send_text(f"COMPLETED_JOB||||{results}")
                    pending_jobs = False
                    clients[client_id]["jobs"].pop()

    except WebSocketDisconnect:
        print("Disconnected")


@app.post("/check_frq_answer")
def similarity(item: classes.similarity_query):
    # similarity = cosine(model.encode([item.input])[0], model.encode([item.target])[0])
    print(item)
    # return {"correct": similarity > .85}
    similarity = web_model.predict([(item.input, item.target)])[0]
    print(
        similarity
    )
    return {"correct": bool(similarity > 3.65)}


if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=8000)
