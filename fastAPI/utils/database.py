# fastAPI/app/utils/database.py
import firebase_admin
from firebase_admin import credentials, firestore
from utils.config import settings

def init_firebase():
    if not firebase_admin._apps:
        cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS)
        firebase_admin.initialize_app(cred)

def get_db():
    init_firebase()
    db = firestore.client()
    return db
