from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from models.ride import Location, RideType
import uuid

class DiscoveryItem(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str
    location: Location
    estimated_fare: float
    estimated_time: str
    rating: float
    popularity_score: int = 0
    image_url: Optional[str] = None
    description: Optional[str] = None
    tags: List[str] = []
    is_featured: bool = False
    created_at: datetime = Field(default_factory=datetime.utcnow)
    
    @property
    def formatted_price(self) -> str:
        return f"${self.estimated_fare:.0f}"

class DiscoveryCreate(BaseModel):
    title: str
    location: Location
    estimated_fare: float
    estimated_time: str
    rating: float = 4.5
    popularity_score: int = 0
    image_url: Optional[str] = None
    description: Optional[str] = None
    tags: List[str] = []
    is_featured: bool = False

class PopularLocation(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    address: str
    latitude: float
    longitude: float
    visit_count: int = 0
    average_rating: float = 4.5
    category: str = "general"  # shopping, entertainment, transport, etc.
    
class SavedLocation(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    name: str
    address: str
    latitude: float
    longitude: float
    category: str = "personal"  # home, work, favorite, etc.
    created_at: datetime = Field(default_factory=datetime.utcnow)