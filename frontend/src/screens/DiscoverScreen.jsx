import { useState, useEffect } from "react";
import { Search, Image as ImageIcon } from "lucide-react";
import { Button } from "../components/ui/button";
import { Card, CardContent } from "../components/ui/card";
import { useToast } from "../hooks/use-toast";
import { mockData } from "../data/mockData"; // Corrected import

const DiscoverScreen = () => {
  const [items, setItems] = useState([]);
  const { toast } = useToast();

  useEffect(() => {
    const loadItems = () => {
      try {
        // Use mock data and make titles generic
        const sourceItems = mockData.discoveries || [];
        const genericItems = sourceItems.map((item, index) => ({
          id: item.id || Math.random().toString(36).substr(2, 9),
          // Use a generic title
          title: `Collection Item ${index + 1}`,
          // category: `Abstract ${String.fromCharCode(65 + (index % 5))}`, // Example of more varied generic category
          // The image URL from mockData is fine as a placeholder string; we are rendering ImageIcon
          imageUrl: item.image
        }));

        // Ensure enough items for visual diversity if possible, or repeat if few.
        const displayItems = [];
        if (genericItems.length > 0) {
          for (let i = 0; i < 10; i++) { // Aim for 10 items for the grid
            displayItems.push(genericItems[i % genericItems.length]);
          }
        }
        setItems(displayItems);

      } catch (error) {
        console.error('Failed to load discovery items:', error);
        toast({
          title: "Error",
          description: "Failed to load items.",
          variant: "destructive",
        });
      }
    };
    loadItems();
  }, [toast]);

  return (
    <div className="h-screen bg-slate-50 overflow-y-auto p-6 pt-8">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold text-gray-800">
          Discover
        </h1>
        <Button variant="ghost" size="icon" className="text-gray-600 hover:text-gray-800 hover:bg-slate-200 rounded-full"> {/* Styled search button */}
          <Search size={22} />
        </Button>
      </div>

      {/* Staggered grid for images */}
      {items.length > 0 ? (
        <div className="columns-2 md:columns-3 gap-4 space-y-4">
          {items.map((item, index) => (
            <Card
              key={item.id || index}
              className="break-inside-avoid border-gray-200 shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-1 bg-white rounded-lg overflow-hidden"
            >
              {/* Image Placeholder */}
              <div
                className={`aspect-square bg-gray-200 flex items-center justify-center
                            ${index % 3 === 0 ? 'aspect-[3/4]' : (index % 3 === 1 ? 'aspect-[4/3]' : 'aspect-square')}`} // Varying aspect ratios for stagger
              >
                {/* Replace with actual <img /> tag if using imageUrl */}
                {/* <img src={item.imageUrl} alt={item.title} className="w-full h-full object-cover" /> */}
                <ImageIcon size={48} className="text-gray-400" />
              </div>
              {/* Minimal content, can be removed for pure visual feed */}
              <CardContent className="p-3">
                <h3 className="font-medium text-sm text-gray-700 truncate">{item.title}</h3>
                {/* <p className="text-xs text-gray-500">{item.category}</p> */}
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <div className="text-center py-12 text-gray-500">
          <ImageIcon size={48} className="mx-auto mb-4 text-gray-400" />
          <p>No items to display.</p>
          <p className="text-sm">Check back later for new content!</p>
        </div>
      )}
    </div>
  );
};

export default DiscoverScreen;
