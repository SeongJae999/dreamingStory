# fastAPI/app/models/user.py
from pydantic import BaseModel

class User(BaseModel):
    uid: str
    email: str
    display_name: str = None
    photo_url: str = None
