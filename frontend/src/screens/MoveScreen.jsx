import { useState, useEffect } from "react";
import { Car, MapPin, Star } from "lucide-react";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Card, CardContent } from "../components/ui/card";
import { useToast } from "../hooks/use-toast";
import { rideAPI } from "../services/api";
import { useAuth } from "../context/AuthContext";

const MoveScreen = () => {
  const [fromLocation, setFromLocation] = useState("");
  const [toLocation, setToLocation] = useState("");
  const [rideOptions, setRideOptions] = useState([]);
  const [loading, setLoading] = useState(false);
  const { toast } = useToast();
  const { isAuthenticated } = useAuth();

  // Load ride options when locations are entered
  useEffect(() => {
    if (fromLocation && toLocation) {
      const loadRideOptions = async () => {
        try {
          setLoading(true);
          // Mock coordinates for now
          const options = await rideAPI.getRideOptions(40.7128, -74.0060, 40.7589, -73.9851);
          setRideOptions(options);
        } catch (error) {
          console.error('Failed to load ride options:', error);
          toast({
            title: "Error",
            description: "Failed to load ride options",
            variant: "destructive",
          });
        } finally {
          setLoading(false);
        }
      };
      loadRideOptions();
    } else {
      setRideOptions([]); // Clear options if locations are cleared
    }
  }, [fromLocation, toLocation, toast]);

  const handleRequestRide = async (rideType) => {
    if (!isAuthenticated) {
      toast({
        title: "Authentication Required",
        description: "Please log in to proceed", // More generic
        variant: "destructive",
      });
      return;
    }

    try {
      setLoading(true);
      const rideRequest = {
        pickup_location: {
          address: fromLocation,
          latitude: 40.7128, // Mock
          longitude: -74.0060 // Mock
        },
        destination_location: {
          address: toLocation,
          latitude: 40.7589, // Mock
          longitude: -73.9851 // Mock
        },
        ride_type: rideType, // This is specific, but the backend expects it. UI can be generic.
        estimated_fare: rideOptions.find(opt => opt.type === rideType)?.estimated_fare || 0
      };

      const ride = await rideAPI.createRideRequest(rideRequest);
      toast({
        title: "Request Confirmed!", // More generic
        description: `Your request for ${rideType} has been confirmed. Details: ${ride.driver_name}`, // Keep some detail for now
      });
    } catch (error) {
      console.error('Failed to submit request:', error);
      toast({
        title: "Error",
        description: "Failed to submit request. Please try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="h-screen bg-gradient-to-br from-blue-50 to-indigo-50 overflow-y-auto p-6 pt-8"> {/* Added more top padding */}
      <h1 className="text-3xl font-bold mb-8 text-gray-800"> {/* Changed title & styling */}
        Set Route
      </h1>

      {/* Location inputs */}
      <div className="space-y-4 mb-6">
        <div className="relative">
          <MapPin size={20} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" /> {/* Adjusted icon positioning */}
          <Input
            placeholder="Pickup Location" // Changed placeholder
            value={fromLocation}
            onChange={(e) => setFromLocation(e.target.value)}
            className="pl-12 h-14 text-base border-gray-300 focus:border-indigo-500 rounded-xl bg-white shadow-sm" // Adjusted styling
          />
        </div>
        <div className="relative">
          <MapPin size={20} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" /> {/* Adjusted icon positioning */}
          <Input
            placeholder="Destination" // Changed placeholder
            value={toLocation}
            onChange={(e) => setToLocation(e.target.value)}
            className="pl-12 h-14 text-base border-gray-300 focus:border-indigo-500 rounded-xl bg-white shadow-sm" // Adjusted styling
          />
        </div>
      </div>

      {/* Map placeholder */}
      <div className="bg-gray-200 rounded-2xl h-64 mb-6 flex items-center justify-center relative overflow-hidden shadow"> {/* Added shadow */}
        <div className="absolute inset-0 bg-gradient-to-br from-gray-200 to-gray-300"></div>
        <div className="z-10 text-center">
          <div className="w-16 h-16 bg-white/50 rounded-full flex items-center justify-center mx-auto mb-3 backdrop-blur-sm">
            <MapPin size={28} className="text-gray-600" />
          </div>
          <p className="text-gray-700 font-medium text-lg">Map Area</p> {/* Changed text */}
        </div>
      </div>

      {/* Ride options */}
      {rideOptions.length > 0 && (
        <div className="space-y-3 mb-6">
          <h2 className="text-xl font-semibold text-gray-700 mb-3">Available Options</h2> {/* Added section title */}
          {rideOptions.map((option, index) => (
            <Card key={index} className="border border-gray-200 hover:border-indigo-400 transition-all duration-300 cursor-pointer hover:shadow-lg bg-white shadow-sm"> {/* Adjusted styling */}
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-4"> {/* Increased spacing */}
                    <div className="w-12 h-12 bg-gradient-to-br from-indigo-500 to-blue-500 rounded-lg flex items-center justify-center shadow"> {/* Adjusted icon bg */}
                      <Car size={22} className="text-white" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-gray-800 text-lg">{option.type}</h3> {/* Made type more prominent */}
                      <p className="text-sm text-gray-500">{option.estimated_time}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-xl text-indigo-600">${option.estimated_fare?.toFixed(2)}</p> {/* Styled price */}
                    <div className="flex items-center justify-end mt-1"> {/* Ensured rating is aligned right */}
                      <Star size={14} className="text-yellow-400 fill-yellow-400" /> {/* Ensured star is filled */}
                      <span className="text-sm text-gray-500 ml-1">{option.rating}</span>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {/* Action button */}
      <Button
        size="lg"
        className="w-full h-16 bg-indigo-600 hover:bg-indigo-700 text-lg font-semibold rounded-xl shadow-md hover:shadow-lg transition-all duration-300 transform hover:scale-[1.02] active:scale-[0.98]" // Adjusted styling & label
        onClick={() => {
          if (rideOptions.length > 0 && fromLocation && toLocation) {
            // For now, let's assume user wants the first option if multiple are shown
            // Or, this button could change to "Select an Option" if rideOptions exist but none are "selected"
            handleRequestRide(rideOptions[0].type);
          } else if (!fromLocation || !toLocation) {
            toast({
              title: "Missing Information", // More generic
              description: "Please enter pickup and destination locations.",
              variant: "default", // Less alarming than destructive
            });
          } else {
             toast({
              title: "No Options Available",
              description: "Could not find options for the selected locations.",
              variant: "default",
            });
          }
        }}
        disabled={loading || !fromLocation || !toLocation}
      >
        {loading ? "Processing..." : (rideOptions.length > 0 ? "Confirm Selection" : "View Options")} {/* Dynamic label */}
      </Button>
    </div>
  );
};

export default MoveScreen;
