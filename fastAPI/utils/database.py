# fastAPI/app/utils/database.py
from utils.config import settings
from firebase_admin import credentials, firestore
import firebase_admin
import logging

def init_firebase():
    if not firebase_admin._apps:
        try:
            cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS)
            firebase_admin.initialize_app(cred)
            logging.info("Firebase Admin SDK initialized successfully.")
        except Exception as e:
            logging.error(f"Firebase initialization failed: {e}")
            raise e

def get_db():
    init_firebase()
    db = firestore.client()
    return db