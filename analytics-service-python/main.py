# main.py
# This file initializes the FastAPI application.
# I load my analytics router here so all stats-related endpoints stay organized.

from fastapi import FastAPI
from routers import stats   # Importing my stats router (analytics module)

app = FastAPI()

@app.get("/api/health")
def health():
    # This endpoint is just to verify that the server is running properly.
    return {"status": "ok"}

# Connecting my stats router under the /stats prefix.
# All analytics endpoints will be added inside routers/stats.py.
app.include_router(stats.router, prefix="/stats")
