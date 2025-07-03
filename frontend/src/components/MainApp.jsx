import { useState } from "react";
import { Camera, Search, Car, User, MapPin, Clock, Star, Settings, History } from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Avatar, AvatarImage, AvatarFallback } from "./ui/avatar";
import { Badge } from "./ui/badge";
import { mockData } from "../data/mockData";

const MainApp = () => {
  const [activeTab, setActiveTab] = useState("camera");
  const [fromLocation, setFromLocation] = useState("");
  const [toLocation, setToLocation] = useState("");

  const TabButton = ({ id, icon: Icon, label, isActive, onClick }) => (
    <button
      onClick={onClick}
      className={`flex flex-col items-center justify-center p-3 rounded-2xl transition-all duration-300 transform ${
        isActive
          ? "bg-gradient-to-br from-purple-500 to-pink-500 text-white shadow-lg scale-105"
          : "text-gray-500 hover:text-gray-700 hover:bg-gray-100 hover:scale-102"
      }`}
    >
      <Icon size={24} />
      <span className="text-xs mt-1 font-medium">{label}</span>
    </button>
  );

  const CameraTab = () => (
    <div className="h-screen bg-gradient-to-br from-purple-600 via-pink-600 to-orange-500 relative overflow-hidden">
      {/* Camera overlay effects */}
      <div className="absolute inset-0 bg-black/20"></div>
      
      {/* Top controls */}
      <div className="absolute top-12 left-0 right-0 flex justify-between items-center px-6 z-10">
        <div className="flex space-x-2">
          <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm">
            <span className="text-white font-bold">⚡</span>
          </div>
          <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm">
            <span className="text-white font-bold">🎨</span>
          </div>
        </div>
        <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm">
          <Settings size={20} className="text-white" />
        </div>
      </div>

      {/* Center capture button */}
      <div className="absolute bottom-32 left-1/2 transform -translate-x-1/2 z-10">
        <button className="w-24 h-24 bg-white rounded-full shadow-2xl flex items-center justify-center transition-all duration-300 hover:scale-110 active:scale-95">
          <div className="w-20 h-20 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center">
            <Camera size={32} className="text-white" />
          </div>
        </button>
      </div>

      {/* Bottom actions */}
      <div className="absolute bottom-20 left-0 right-0 flex justify-center space-x-6 z-10">
        <button className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm">
          <span className="text-white font-bold">📷</span>
        </button>
        <button className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm">
          <span className="text-white font-bold">🎬</span>
        </button>
      </div>

      {/* Floating elements for visual interest */}
      <div className="absolute top-1/4 left-8 w-4 h-4 bg-white/30 rounded-full animate-pulse"></div>
      <div className="absolute top-1/3 right-12 w-6 h-6 bg-yellow-400/40 rounded-full animate-bounce"></div>
      <div className="absolute bottom-1/3 left-12 w-3 h-3 bg-blue-400/40 rounded-full animate-ping"></div>
    </div>
  );

  const DiscoverTab = () => (
    <div className="h-screen bg-gradient-to-br from-pink-50 to-purple-50 overflow-y-auto">
      <div className="p-6">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-2xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
            Discover Rides
          </h1>
          <Button size="sm" className="bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600">
            <Search size={16} />
          </Button>
        </div>

        {/* Pinterest-style staggered grid */}
        <div className="columns-2 gap-4 space-y-4">
          {mockData.discoveries.map((item, index) => (
            <Card key={index} className="break-inside-avoid border-0 shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-2 bg-white/80 backdrop-blur-sm">
              <div className="aspect-square bg-gradient-to-br from-purple-200 to-pink-200 rounded-t-lg relative overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-br from-purple-400/20 to-pink-400/20"></div>
                <div className="absolute bottom-4 left-4 right-4">
                  <div className="bg-white/90 rounded-full px-3 py-1 backdrop-blur-sm">
                    <span className="text-sm font-medium">{item.location}</span>
                  </div>
                </div>
              </div>
              <CardContent className="p-4">
                <div className="flex items-center justify-between mb-2">
                  <span className="font-semibold text-gray-800">{item.title}</span>
                  <Badge variant="secondary" className="bg-purple-100 text-purple-700">
                    {item.price}
                  </Badge>
                </div>
                <div className="flex items-center space-x-2 text-sm text-gray-600">
                  <Clock size={14} />
                  <span>{item.time}</span>
                  <Star size={14} className="text-yellow-400 fill-current" />
                  <span>{item.rating}</span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );

  const MoveTab = () => (
    <div className="h-screen bg-gradient-to-br from-blue-50 to-indigo-50 overflow-y-auto">
      <div className="p-6">
        <h1 className="text-2xl font-bold mb-6 bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
          Book a Ride
        </h1>

        {/* Location inputs */}
        <div className="space-y-4 mb-6">
          <div className="relative">
            <MapPin size={20} className="absolute left-3 top-3 text-blue-500" />
            <Input
              placeholder="From where?"
              value={fromLocation}
              onChange={(e) => setFromLocation(e.target.value)}
              className="pl-12 h-12 border-2 border-blue-200 focus:border-blue-500 rounded-xl bg-white/80 backdrop-blur-sm"
            />
          </div>
          <div className="relative">
            <MapPin size={20} className="absolute left-3 top-3 text-indigo-500" />
            <Input
              placeholder="Where to?"
              value={toLocation}
              onChange={(e) => setToLocation(e.target.value)}
              className="pl-12 h-12 border-2 border-indigo-200 focus:border-indigo-500 rounded-xl bg-white/80 backdrop-blur-sm"
            />
          </div>
        </div>

        {/* Map placeholder */}
        <div className="bg-gray-300 rounded-2xl h-64 mb-6 flex items-center justify-center relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-br from-gray-300 to-gray-400"></div>
          <div className="z-10 text-center">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-2">
              <MapPin size={24} className="text-white" />
            </div>
            <p className="text-white font-medium">Map will load here</p>
          </div>
        </div>

        {/* Ride options */}
        <div className="space-y-3 mb-6">
          {mockData.rideOptions.map((option, index) => (
            <Card key={index} className="border-2 border-gray-200 hover:border-blue-400 transition-all duration-300 cursor-pointer hover:shadow-lg bg-white/80 backdrop-blur-sm">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-gradient-to-br from-blue-400 to-indigo-400 rounded-full flex items-center justify-center">
                      <Car size={20} className="text-white" />
                    </div>
                    <div>
                      <h3 className="font-semibold">{option.type}</h3>
                      <p className="text-sm text-gray-600">{option.time}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-lg">{option.price}</p>
                    <div className="flex items-center">
                      <Star size={14} className="text-yellow-400 fill-current" />
                      <span className="text-sm ml-1">{option.rating}</span>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Request button */}
        <Button 
          size="lg" 
          className="w-full h-14 bg-gradient-to-r from-blue-500 to-indigo-500 hover:from-blue-600 hover:to-indigo-600 text-lg font-bold rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105"
        >
          Request V
        </Button>
      </div>
    </div>
  );

  const ProfileTab = () => (
    <div className="h-screen bg-gradient-to-br from-gray-50 to-blue-50 overflow-y-auto">
      <div className="p-6">
        {/* Profile header */}
        <div className="flex items-center space-x-4 mb-8">
          <Avatar className="w-20 h-20 border-4 border-white shadow-lg">
            <AvatarImage src="/api/placeholder/80/80" />
            <AvatarFallback className="bg-gradient-to-br from-purple-500 to-pink-500 text-white text-xl font-bold">
              JD
            </AvatarFallback>
          </Avatar>
          <div>
            <h1 className="text-2xl font-bold">John Doe</h1>
            <p className="text-gray-600">Premium Rider</p>
            <div className="flex items-center mt-1">
              <Star size={16} className="text-yellow-400 fill-current" />
              <span className="text-sm ml-1">4.9 Rating</span>
            </div>
          </div>
        </div>

        {/* Recent trips */}
        <div className="mb-8">
          <h2 className="text-xl font-bold mb-4 flex items-center">
            <History size={20} className="mr-2" />
            Recent Trips
          </h2>
          <div className="space-y-3">
            {mockData.recentTrips.map((trip, index) => (
              <Card key={index} className="border-0 shadow-md hover:shadow-lg transition-shadow bg-white/80 backdrop-blur-sm">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-3">
                      <div className="w-10 h-10 bg-gradient-to-br from-blue-400 to-indigo-400 rounded-full flex items-center justify-center">
                        <Car size={16} className="text-white" />
                      </div>
                      <div>
                        <p className="font-medium">{trip.route}</p>
                        <p className="text-sm text-gray-600">{trip.date}</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="font-bold">{trip.amount}</p>
                      <p className="text-sm text-gray-600">{trip.duration}</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Settings */}
        <div>
          <h2 className="text-xl font-bold mb-4 flex items-center">
            <Settings size={20} className="mr-2" />
            Settings
          </h2>
          <div className="space-y-2">
            {mockData.settingsOptions.map((option, index) => (
              <Card key={index} className="border-0 shadow-md hover:shadow-lg transition-shadow cursor-pointer bg-white/80 backdrop-blur-sm">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <span className="font-medium">{option.label}</span>
                    <span className="text-gray-400">→</span>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </div>
    </div>
  );

  const renderActiveTab = () => {
    switch (activeTab) {
      case "camera":
        return <CameraTab />;
      case "discover":
        return <DiscoverTab />;
      case "move":
        return <MoveTab />;
      case "profile":
        return <ProfileTab />;
      default:
        return <CameraTab />;
    }
  };

  return (
    <div className="min-h-screen bg-white">
      {/* Main content */}
      <div className="pb-20">
        {renderActiveTab()}
      </div>

      {/* Bottom navigation */}
      <div className="fixed bottom-0 left-0 right-0 bg-white/90 backdrop-blur-md border-t border-gray-200 px-6 py-4">
        <div className="flex justify-around items-center">
          <TabButton
            id="camera"
            icon={Camera}
            label="Capture"
            isActive={activeTab === "camera"}
            onClick={() => setActiveTab("camera")}
          />
          <TabButton
            id="discover"
            icon={Search}
            label="Discover"
            isActive={activeTab === "discover"}
            onClick={() => setActiveTab("discover")}
          />
          <TabButton
            id="move"
            icon={Car}
            label="Move"
            isActive={activeTab === "move"}
            onClick={() => setActiveTab("move")}
          />
          <TabButton
            id="profile"
            icon={User}
            label="Profile"
            isActive={activeTab === "profile"}
            onClick={() => setActiveTab("profile")}
          />
        </div>
      </div>
    </div>
  );
};

export default MainApp;