# models/schemas.py
# This file contains the Pydantic models used for shaping the JSON responses.
# I'm starting with the CategoryTotal model, which represents the structure
# returned by my /stats/by-category endpoint.

from pydantic import BaseModel

class CategoryTotal(BaseModel):
    category: str   # Name of the category (e.g., "Food")
    total: float    # Total amount for that category
