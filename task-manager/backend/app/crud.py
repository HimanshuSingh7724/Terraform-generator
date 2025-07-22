from .models import tasks
from .schemas import TaskCreate
from databases import Database

async def get_tasks(db: Database):
    query = tasks.select()
    return await db.fetch_all(query)

async def get_task(db: Database, task_id: int):
    query = tasks.select().where(tasks.c.id == task_id)
    return await db.fetch_one(query)

async def create_task(db: Database, task: TaskCreate):
    query = tasks.insert().values(
        title=task.title,
        description=task.description,
        completed=task.completed
    )
    task_id = await db.execute(query)
    return {**task.dict(), "id": task_id}

async def update_task(db: Database, task_id: int, task: TaskCreate):
    query = tasks.update().where(tasks.c.id == task_id).values(
        title=task.title,
        description=task.description,
        completed=task.completed
    )
    await db.execute(query)
    return await get_task(db, task_id)

async def delete_task(db: Database, task_id: int):
    query = tasks.delete().where(tasks.c.id == task_id)
    await db.execute(query)
    return {"message": "Task deleted"}
