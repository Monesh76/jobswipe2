import React from 'react';
import { Heart, X } from "lucide-react";
import { Button } from '@/components/ui/button';

const SwipeControls = ({ onSwipeLeft, onSwipeRight, disabled }) => {
  return (
    <div className="flex justify-center gap-8 p-4">
      <Button 
        onClick={onSwipeLeft}
        disabled={disabled}
        variant="outline"
        size="lg"
        className="rounded-full p-6 bg-red-50 hover:bg-red-100"
      >
        <X className="h-8 w-8 text-red-500" />
      </Button>
      
      <Button
        onClick={onSwipeRight}
        disabled={disabled}
        variant="outline"
        size="lg"
        className="rounded-full p-6 bg-green-50 hover:bg-green-100"
      >
        <Heart className="h-8 w-8 text-green-500" />
      </Button>
    </div>
  );
};

export default SwipeControls;