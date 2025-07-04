import { useState } from "react";
import { Camera, Search, Car, User } from "lucide-react"; // Removed unused icons like MapPin, Clock, Star, Settings, History, Plus
// Removed unused UI component imports: Input, Card related, Avatar, Badge
// Removed unused hook imports: useToast (will be used in child screens), discoveryAPI, rideAPI, tripAPI, useAuth (will be used in child screens)

// Import screen components
import SnapScreen from "../screens/SnapScreen";
import DiscoverScreen from "../screens/DiscoverScreen";
import MoveScreen from "../screens/MoveScreen";
import MeScreen from "../screens/MeScreen";

const MainApp = () => {
  const [activeTab, setActiveTab] = useState("snap"); // Default to "snap" (formerly camera)

  // TabButton component remains here as it's integral to MainApp's layout
  const TabButton = ({ id, icon: Icon, label, isActive, onClick }) => (
    <button
      onClick={onClick}
      className={`flex flex-col items-center justify-center flex-1 py-2 px-1 rounded-lg transition-all duration-200 ease-in-out
                  ${isActive ? "text-indigo-600" : "text-gray-500 hover:text-gray-700"}`}
      aria-current={isActive ? "page" : undefined}
    >
      <Icon size={isActive ? 26 : 24} className={`mb-0.5 transition-all ${isActive ? 'transform scale-110' : ''}`} />
      <span className={`text-xs font-medium transition-all ${isActive ? "font-semibold" : "font-normal"}`}>{label}</span>
    </button>
  );

  const renderActiveTab = () => {
    switch (activeTab) {
      case "snap": // Renamed from "camera"
        return <SnapScreen />;
      case "discover":
        return <DiscoverScreen />;
      case "move":
        return <MoveScreen />;
      case "me": // Renamed from "profile"
        return <MeScreen />;
      default:
        return <SnapScreen />; // Default to SnapScreen
    }
  };

  return (
    <div className="min-h-screen bg-slate-100 flex flex-col"> {/* Changed overall bg for better contrast with content area if needed */}
      {/* Main content area */}
      {/* The pb-20 (padding-bottom) is to prevent content from being hidden by the fixed bottom nav */}
      <main className="flex-grow overflow-y-auto pb-20">
        {renderActiveTab()}
      </main>

      {/* Bottom navigation */}
      {/* Adjusted styling for a more professional look */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white shadow-top-md border-t border-gray-200"> {/* Custom shadow class if needed */}
        <div className="max-w-md mx-auto flex justify-around items-center px-2 py-2.5"> {/* Added max-width for typical mobile view, adjusted padding */}
          <TabButton
            id="snap"
            icon={Camera} // Icon for Snap
            label="Snap"   // Label "Snap"
            isActive={activeTab === "snap"}
            onClick={() => setActiveTab("snap")}
          />
          <TabButton
            id="discover"
            icon={Search} // Icon for Discover
            label="Discover"
            isActive={activeTab === "discover"}
            onClick={() => setActiveTab("discover")}
          />
          <TabButton
            id="move"
            icon={Car}    // Icon for Move
            label="Move"
            isActive={activeTab === "move"}
            onClick={() => setActiveTab("move")}
          />
          <TabButton
            id="me"
            icon={User}   // Icon for Me
            label="Me"     // Label "Me"
            isActive={activeTab === "me"}
            onClick={() => setActiveTab("me")}
          />
        </div>
      </nav>
    </div>
  );
};

export default MainApp;