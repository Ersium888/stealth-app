from fastapi import FastAPI, APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from dotenv import load_dotenv
from starlette.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
import os
import logging
from pathlib import Path
from typing import List, Optional
import uuid
from datetime import datetime, timedelta
import jwt
from passlib.context import CryptContext
import random

# Import models
import sys
sys.path.append('/app/backend')
from models.user import UserCreate, UserResponse, UserLogin, UserUpdate
from models.ride import RideRequest, RideResponse, RideOption, RideType, RideStatus
from models.trip import TripCreate, TripResponse
from models.discovery import DiscoveryCreate, DiscoveryItem, PopularLocation, SavedLocation

ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

# MongoDB connection
mongo_url = os.environ['MONGO_URL']
client = AsyncIOMotorClient(mongo_url)
db = client[os.environ['DB_NAME']]

# Security
SECRET_KEY = os.environ.get('SECRET_KEY', 'your-secret-key-here')
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

# Create the main app
app = FastAPI(title="VRide API", version="1.0.0")

# Create a router with the /api prefix
api_router = APIRouter(prefix="/api")

# Helper functions
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except jwt.PyJWTError:
        raise credentials_exception
    
    user = await db.users.find_one({"id": user_id})
    if user is None:
        raise credentials_exception
    return user

# Initialize mock data
async def init_mock_data():
    # Check if discovery items exist
    existing_discovery = await db.discovery.find_one()
    if not existing_discovery:
        mock_discoveries = [
            {
                "id": str(uuid.uuid4()),
                "title": "Quick Downtown",
                "location": {"address": "City Center", "latitude": 40.7128, "longitude": -74.0060},
                "estimated_fare": 12.0,
                "estimated_time": "5 min",
                "rating": 4.8,
                "popularity_score": 85,
                "is_featured": True,
                "tags": ["downtown", "business", "quick"],
                "created_at": datetime.utcnow()
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Airport Express",
                "location": {"address": "Terminal 1", "latitude": 40.6413, "longitude": -73.7781},
                "estimated_fare": 25.0,
                "estimated_time": "12 min",
                "rating": 4.9,
                "popularity_score": 92,
                "is_featured": True,
                "tags": ["airport", "express", "travel"],
                "created_at": datetime.utcnow()
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Mall Shuttle",
                "location": {"address": "Shopping District", "latitude": 40.7589, "longitude": -73.9851},
                "estimated_fare": 8.0,
                "estimated_time": "8 min",
                "rating": 4.7,
                "popularity_score": 78,
                "is_featured": False,
                "tags": ["shopping", "mall", "leisure"],
                "created_at": datetime.utcnow()
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Beach Ride",
                "location": {"address": "Sunset Beach", "latitude": 40.5795, "longitude": -74.1502},
                "estimated_fare": 18.0,
                "estimated_time": "15 min",
                "rating": 4.9,
                "popularity_score": 89,
                "is_featured": True,
                "tags": ["beach", "sunset", "leisure"],
                "created_at": datetime.utcnow()
            },
            {
                "id": str(uuid.uuid4()),
                "title": "University Hub",
                "location": {"address": "Campus Area", "latitude": 40.8075, "longitude": -73.9626},
                "estimated_fare": 6.0,
                "estimated_time": "4 min",
                "rating": 4.6,
                "popularity_score": 71,
                "is_featured": False,
                "tags": ["university", "campus", "student"],
                "created_at": datetime.utcnow()
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Night Life",
                "location": {"address": "Entertainment District", "latitude": 40.7505, "longitude": -73.9934},
                "estimated_fare": 15.0,
                "estimated_time": "10 min",
                "rating": 4.8,
                "popularity_score": 82,
                "is_featured": True,
                "tags": ["nightlife", "entertainment", "bars"],
                "created_at": datetime.utcnow()
            }
        ]
        await db.discovery.insert_many(mock_discoveries)

# Authentication endpoints
@api_router.post("/auth/register", response_model=UserResponse)
async def register(user: UserCreate):
    # Check if user already exists
    existing_user = await db.users.find_one({"email": user.email})
    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Email already registered"
        )
    
    # Hash password and create user
    hashed_password = get_password_hash(user.password)
    user_dict = user.dict()
    del user_dict["password"]
    user_dict["hashed_password"] = hashed_password
    user_dict["id"] = str(uuid.uuid4())
    user_dict["created_at"] = datetime.utcnow()
    user_dict["updated_at"] = datetime.utcnow()
    
    await db.users.insert_one(user_dict)
    return UserResponse(**user_dict)

@api_router.post("/auth/login")
async def login(user: UserLogin):
    db_user = await db.users.find_one({"email": user.email})
    if not db_user or not verify_password(user.password, db_user["hashed_password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": db_user["id"]}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer", "user": UserResponse(**db_user)}

# User endpoints
@api_router.get("/users/me", response_model=UserResponse)
async def get_current_user_profile(current_user: dict = Depends(get_current_user)):
    return UserResponse(**current_user)

@api_router.put("/users/me", response_model=UserResponse)
async def update_user_profile(
    user_update: UserUpdate,
    current_user: dict = Depends(get_current_user)
):
    update_data = user_update.dict(exclude_unset=True)
    if update_data:
        update_data["updated_at"] = datetime.utcnow()
        await db.users.update_one(
            {"id": current_user["id"]},
            {"$set": update_data}
        )
    
    updated_user = await db.users.find_one({"id": current_user["id"]})
    return UserResponse(**updated_user)

# Discovery endpoints
@api_router.get("/discovery", response_model=List[DiscoveryItem])
async def get_discovery_items():
    items = await db.discovery.find().to_list(1000)
    return [DiscoveryItem(**item) for item in items]

@api_router.post("/discovery", response_model=DiscoveryItem)
async def create_discovery_item(item: DiscoveryCreate):
    item_dict = item.dict()
    item_dict["id"] = str(uuid.uuid4())
    item_dict["created_at"] = datetime.utcnow()
    await db.discovery.insert_one(item_dict)
    return DiscoveryItem(**item_dict)

# Ride endpoints
@api_router.post("/rides/options", response_model=List[RideOption])
async def get_ride_options(pickup_lat: float, pickup_lng: float, dest_lat: float, dest_lng: float):
    # Mock ride options calculation
    base_fare = 10.0
    distance_factor = abs(pickup_lat - dest_lat) + abs(pickup_lng - dest_lng)
    
    options = [
        RideOption(
            type=RideType.ECONOMY,
            estimated_time=f"{random.randint(3, 8)} min away",
            estimated_fare=base_fare + (distance_factor * 5),
            rating=4.8,
            available_drivers=random.randint(3, 8)
        ),
        RideOption(
            type=RideType.COMFORT,
            estimated_time=f"{random.randint(2, 6)} min away",
            estimated_fare=(base_fare + (distance_factor * 5)) * 1.5,
            rating=4.9,
            available_drivers=random.randint(2, 5)
        ),
        RideOption(
            type=RideType.PREMIUM,
            estimated_time=f"{random.randint(4, 10)} min away",
            estimated_fare=(base_fare + (distance_factor * 5)) * 2.0,
            rating=4.9,
            available_drivers=random.randint(1, 3)
        )
    ]
    
    return options

@api_router.post("/rides", response_model=RideResponse)
async def create_ride_request(
    ride_request: RideRequest,
    current_user: dict = Depends(get_current_user)
):
    ride_dict = ride_request.dict()
    ride_dict["id"] = str(uuid.uuid4())
    ride_dict["user_id"] = current_user["id"]
    ride_dict["status"] = RideStatus.REQUESTED
    ride_dict["created_at"] = datetime.utcnow()
    ride_dict["updated_at"] = datetime.utcnow()
    
    # Mock driver assignment
    drivers = ["John Smith", "Maria Garcia", "David Johnson", "Lisa Chen"]
    ride_dict["driver_name"] = random.choice(drivers)
    ride_dict["driver_rating"] = round(random.uniform(4.5, 5.0), 1)
    ride_dict["driver_id"] = str(uuid.uuid4())
    ride_dict["estimated_arrival"] = f"{random.randint(3, 8)} min"
    
    await db.rides.insert_one(ride_dict)
    return RideResponse(**ride_dict)

@api_router.get("/rides", response_model=List[RideResponse])
async def get_user_rides(current_user: dict = Depends(get_current_user)):
    rides = await db.rides.find({"user_id": current_user["id"]}).to_list(100)
    return [RideResponse(**ride) for ride in rides]

@api_router.get("/rides/{ride_id}", response_model=RideResponse)
async def get_ride(ride_id: str, current_user: dict = Depends(get_current_user)):
    ride = await db.rides.find_one({"id": ride_id, "user_id": current_user["id"]})
    if not ride:
        raise HTTPException(status_code=404, detail="Ride not found")
    return RideResponse(**ride)

# Trip endpoints
@api_router.get("/trips", response_model=List[TripResponse])
async def get_user_trips(current_user: dict = Depends(get_current_user)):
    trips = await db.trips.find({"user_id": current_user["id"]}).sort("created_at", -1).to_list(100)
    return [TripResponse(**trip) for trip in trips]

@api_router.post("/trips", response_model=TripResponse)
async def create_trip(
    trip: TripCreate,
    current_user: dict = Depends(get_current_user)
):
    trip_dict = trip.dict()
    trip_dict["id"] = str(uuid.uuid4())
    trip_dict["created_at"] = datetime.utcnow()
    
    await db.trips.insert_one(trip_dict)
    
    # Update user's total trips
    await db.users.update_one(
        {"id": current_user["id"]},
        {"$inc": {"total_trips": 1}}
    )
    
    return TripResponse(**trip_dict)

# Root endpoint
@api_router.get("/")
async def root():
    return {"message": "VRide API is running", "version": "1.0.0"}

# Health check
@api_router.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.utcnow()}

# Include the router in the main app
app.include_router(api_router)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@app.on_event("startup")
async def startup_event():
    await init_mock_data()
    logger.info("VRide API started successfully")

@app.on_event("shutdown")
async def shutdown_db_client():
    client.close()
    logger.info("Database connection closed")