from databases import Database
from sqlalchemy import create_engine, MetaData

DATABASE_URL = "postgresql+asyncpg://postgres:password@localhost:5432/taskdb"

database = Database(DATABASE_URL)
metadata = MetaData()

engine = create_engine(
    DATABASE_URL.replace("asyncpg", "psycopg2"),
    echo=True,
)
