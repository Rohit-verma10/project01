from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel
from sqlalchemy.orm import Session

from backend.app.database.database import get_db
from backend.app.user import User
from backend.app.utils.security import (
    hash_password,
    verify_password,
    create_access_token
)
from backend.app.dependencies.auth import get_current_user

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)


class RegisterRequest(BaseModel):
    full_name: str
    email: str
    phone: str
    password: str


@router.get("/test")
def test_route():
    return {
        "message": "Auth Route Working"
    }


@router.post("/register")
def register(
    user: RegisterRequest,
    db: Session = Depends(get_db)
):
    new_user = User(
        full_name=user.full_name,
        email=user.email,
        phone=user.phone,
        password=hash_password(user.password)
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {
        "message": "User Registered Successfully",
        "user_id": new_user.id
    }


@router.post("/login")
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    db_user = db.query(User).filter(
        User.email == form_data.username
    ).first()

    if not db_user:
        return {
            "message": "Invalid Email"
        }

    if not verify_password(
        form_data.password,
        db_user.password
    ):
        return {
            "message": "Invalid Password"
        }

    token = create_access_token(
        data={
            "sub": db_user.email
        }
    )

    return {
        "access_token": token,
        "token_type": "bearer"
    }


@router.get("/me")
def get_me(
    current_user: str = Depends(get_current_user)
):
    return {
        "message": "Protected Route Access Granted",
        "email": current_user
    }