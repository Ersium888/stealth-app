export const mockData = {
  discoveries: [
    {
      title: "Quick Downtown",
      location: "City Center",
      price: "$12",
      time: "5 min",
      rating: "4.8",
      image: "/api/placeholder/300/200"
    },
    {
      title: "Airport Express",
      location: "Terminal 1",
      price: "$25",
      time: "12 min",
      rating: "4.9",
      image: "/api/placeholder/300/250"
    },
    {
      title: "Mall Shuttle",
      location: "Shopping District",
      price: "$8",
      time: "8 min",
      rating: "4.7",
      image: "/api/placeholder/300/180"
    },
    {
      title: "Beach Ride",
      location: "Sunset Beach",
      price: "$18",
      time: "15 min",
      rating: "4.9",
      image: "/api/placeholder/300/220"
    },
    {
      title: "University Hub",
      location: "Campus Area",
      price: "$6",
      time: "4 min",
      rating: "4.6",
      image: "/api/placeholder/300/190"
    },
    {
      title: "Night Life",
      location: "Entertainment District",
      price: "$15",
      time: "10 min",
      rating: "4.8",
      image: "/api/placeholder/300/240"
    }
  ],
  
  rideOptions: [
    {
      type: "V-Economy",
      time: "5 min away",
      price: "$12.50",
      rating: "4.8"
    },
    {
      type: "V-Comfort",
      time: "3 min away",
      price: "$18.75",
      rating: "4.9"
    },
    {
      type: "V-Premium",
      time: "7 min away",
      price: "$24.00",
      rating: "4.9"
    }
  ],
  
  recentTrips: [
    {
      route: "Downtown → Airport",
      date: "Today, 2:30 PM",
      amount: "$28.50",
      duration: "22 min"
    },
    {
      route: "Home → Mall",
      date: "Yesterday, 6:15 PM",
      amount: "$12.75",
      duration: "15 min"
    },
    {
      route: "Office → Restaurant",
      date: "2 days ago, 12:45 PM",
      amount: "$9.25",
      duration: "8 min"
    },
    {
      route: "Hotel → Beach",
      date: "3 days ago, 10:20 AM",
      amount: "$18.00",
      duration: "18 min"
    }
  ],
  
  settingsOptions: [
    { label: "Payment Methods", value: "payment" },
    { label: "Ride Preferences", value: "preferences" },
    { label: "Notification Settings", value: "notifications" },
    { label: "Privacy & Security", value: "privacy" },
    { label: "Help & Support", value: "support" },
    { label: "About", value: "about" }
  ]
};