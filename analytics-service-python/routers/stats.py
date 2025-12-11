# routers/stats.py
# This file will contain the analytics endpoints.
# I'm starting with a simple test endpoint to make sure the router works.

from fastapi import APIRouter

# Creating the router object where I will add the analytics endpoints later.
router = APIRouter()

@router.get("/test")
def test():
    # This is a temporary endpoint to confirm that the stats router is connected properly.
    return {"message": "stats router connected"}
