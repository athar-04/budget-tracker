# db/connect.py
# This file sets up the database connection for the analytics service.
# For Day 3 testing, I'm using SQLite because it works without any setup.

from sqlalchemy import create_engine

# SQLite database file (stored inside the analytics-service-python folder)
DB_URL = "sqlite:///./analytics.db"

# Creating the engine that FastAPI will use for running SQL queries.
engine = create_engine(
    DB_URL,
    echo=True,        # Shows SQL in terminal for debugging
    future=True
)

