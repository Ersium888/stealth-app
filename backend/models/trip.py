from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
import sys
sys.path.append('/app/backend')
from models.ride import Location, RideType
import uuid

class TripCreate(BaseModel):
    user_id: str
    pickup_location: Location
    destination_location: Location
    ride_type: RideType
    fare: float
    duration_minutes: int
    distance_km: float
    driver_id: str
    driver_name: str
    driver_rating: float

class TripResponse(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    pickup_location: Location
    destination_location: Location
    ride_type: RideType
    fare: float
    duration_minutes: int
    distance_km: float
    driver_id: str
    driver_name: str
    driver_rating: float
    rating_given: Optional[float] = None
    feedback: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    
    @property
    def route(self) -> str:
        return f"{self.pickup_location.address} → {self.destination_location.address}"
    
    @property
    def formatted_date(self) -> str:
        now = datetime.utcnow()
        diff = now - self.created_at
        
        if diff.days == 0:
            return f"Today, {self.created_at.strftime('%I:%M %p')}"
        elif diff.days == 1:
            return f"Yesterday, {self.created_at.strftime('%I:%M %p')}"
        elif diff.days <= 7:
            return f"{diff.days} days ago, {self.created_at.strftime('%I:%M %p')}"
        else:
            return self.created_at.strftime('%b %d, %Y')
    
    @property
    def formatted_duration(self) -> str:
        return f"{self.duration_minutes} min"
    
    @property
    def formatted_fare(self) -> str:
        return f"${self.fare:.2f}"