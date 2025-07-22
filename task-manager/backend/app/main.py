from fastapi import FastAPI, HTTPException
from .database import database, engine, metadata
from . import models, crud, schemas

app = FastAPI()

metadata.create_all(engine)

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

@app.get("/tasks/", response_model=list[schemas.Task])
async def read_tasks():
    return await crud.get_tasks(database)

@app.get("/tasks/{task_id}", response_model=schemas.Task)
async def read_task(task_id: int):
    task = await crud.get_task(database, task_id)
    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    return task

@app.post("/tasks/", response_model=schemas.Task)
async def create_task(task: schemas.TaskCreate):
    return await crud.create_task(database, task)

@app.put("/tasks/{task_id}", response_model=schemas.Task)
async def update_task(task_id: int, task: schemas.TaskCreate):
    return await crud.update_task(database, task_id, task)

@app.delete("/tasks/{task_id}")
async def delete_task(task_id: int):
    return await crud.delete_task(database, task_id)
