from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum
import uuid

class RideStatus(str, Enum):
    REQUESTED = "requested"
    MATCHED = "matched"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class RideType(str, Enum):
    ECONOMY = "V-Economy"
    COMFORT = "V-Comfort"
    PREMIUM = "V-Premium"

class Location(BaseModel):
    address: str
    latitude: float
    longitude: float
    place_id: Optional[str] = None

class RideRequest(BaseModel):
    pickup_location: Location
    destination_location: Location
    ride_type: RideType
    estimated_fare: Optional[float] = None
    notes: Optional[str] = None

class RideOption(BaseModel):
    type: RideType
    estimated_time: str
    estimated_fare: float
    rating: float
    available_drivers: int = 0

class RideResponse(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    pickup_location: Location
    destination_location: Location
    ride_type: RideType
    status: RideStatus = RideStatus.REQUESTED
    estimated_fare: Optional[float] = None
    actual_fare: Optional[float] = None
    driver_id: Optional[str] = None
    driver_name: Optional[str] = None
    driver_rating: Optional[float] = None
    driver_phone: Optional[str] = None
    estimated_arrival: Optional[str] = None
    notes: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    completed_at: Optional[datetime] = None