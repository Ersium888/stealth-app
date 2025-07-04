import { User, Settings, HelpCircle, LogOut, Activity, ShieldCheck, Palette, CreditCard } from "lucide-react"; // More generic icons
import { Avatar, AvatarImage, AvatarFallback } from "../components/ui/avatar";
import { Card, CardContent } from "../components/ui/card";
import { useAuth } from "../context/AuthContext"; // To get user info and logout
import { useNavigate } from "react-router-dom";
import { useToast } from "../hooks/use-toast";


const MeScreen = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  const handleLogout = () => {
    logout();
    toast({ title: "Logged Out", description: "You have been successfully logged out." });
    navigate("/login");
  };

  // Placeholder user data if not logged in, or for styling.
  const displayUser = user || {
    full_name: "User Name",
    profile_image: "", // "https://github.com/shadcn.png", // Example placeholder image
    // Generic subtitle or detail
    detail: "Active Member",
  };

  const getInitials = (name) => {
    if (!name) return "U";
    return name.split(' ').map(n => n[0]).join('').toUpperCase();
  };

  const menuOptions = [
    { label: "My Activity", icon: Activity, action: () => toast({ title: "My Activity", description: "This section is under development."}) },
    { label: "Preferences", icon: Settings, action: () => toast({ title: "Preferences", description: "This section is under development."}) },
    { label: "Appearance", icon: Palette, action: () => toast({ title: "Appearance", description: "This section is under development."}) },
    { label: "Account Details", icon: CreditCard, action: () => toast({ title: "Account Details", description: "This section is under development."}) },
    { label: "Security", icon: ShieldCheck, action: () => toast({ title: "Security", description: "This section is under development."}) },
    { label: "Support", icon: HelpCircle, action: () => toast({ title: "Support", description: "This section is under development."}) },
  ];

  return (
    <div className="h-screen bg-slate-50 overflow-y-auto p-6 pt-8">
      {/* Profile Header */}
      <div className="flex items-center space-x-5 mb-10"> {/* Increased spacing */}
        <Avatar className="w-24 h-24 border-4 border-white shadow-lg"> {/* Larger avatar */}
          <AvatarImage src={displayUser.profile_image || undefined} alt={displayUser.full_name} />
          <AvatarFallback className="bg-gradient-to-br from-gray-600 to-gray-800 text-white text-3xl font-semibold">
            {getInitials(displayUser.full_name)}
          </AvatarFallback>
        </Avatar>
        <div>
          <h1 className="text-3xl font-bold text-gray-800">{displayUser.full_name}</h1>
          <p className="text-gray-500 text-md">{displayUser.detail}</p>
        </div>
      </div>

      {/* Menu Options */}
      <div className="space-y-3">
        {menuOptions.map((option, index) => (
          <Card
            key={index}
            className="border-gray-200 shadow-sm hover:shadow-lg transition-shadow cursor-pointer bg-white rounded-lg"
            onClick={option.action}
          >
            <CardContent className="p-4 flex items-center justify-between">
              <div className="flex items-center space-x-4">
                <option.icon size={22} className="text-gray-600" />
                <span className="font-medium text-gray-700 text-base">{option.label}</span>
              </div>
              <span className="text-gray-400 text-xl font-light">›</span>
            </CardContent>
          </Card>
        ))}

        {/* Logout Button - styled differently for emphasis */}
        {user && ( // Only show logout if user is authenticated
          <Card
            className="mt-6 border-red-200 shadow-sm hover:shadow-lg transition-shadow cursor-pointer bg-white rounded-lg hover:bg-red-50"
            onClick={handleLogout}
          >
            <CardContent className="p-4 flex items-center justify-between">
              <div className="flex items-center space-x-4">
                <LogOut size={22} className="text-red-500" />
                <span className="font-medium text-red-600 text-base">Logout</span>
              </div>
              <span className="text-red-400 text-xl font-light">›</span>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
};

export default MeScreen;
