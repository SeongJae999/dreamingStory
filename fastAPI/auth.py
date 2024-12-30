# fastAPI/auth.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from firebase_admin import auth as firebase_auth
import logging

security = HTTPBearer()

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    print("Received token:", token)  # 디버깅용 print 문
    try:
        decoded_token = firebase_auth.verify_id_token(token)
        uid = decoded_token.get('uid')
        print("Extracted UID:", uid)  # 디버깅용 print 문
        logging.info(f"Extracted UID: {uid}")
        if not uid:
            logging.error("UID not found in decoded token.")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials",
                headers={"WWW-Authenticate": "Bearer"},
            )
        return uid
    except firebase_admin.auth.InvalidIdTokenError:
        logging.error("Invalid ID token.")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except firebase_admin.auth.ExpiredIdTokenError:
        logging.error("Expired ID token.")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has expired",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except Exception as e:
        logging.error(f"Token verification failed: {e}")
        print("Token verification failed:", e)  # 디버깅용 print 문
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
