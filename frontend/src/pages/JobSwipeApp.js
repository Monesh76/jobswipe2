import React, { useState, useEffect } from 'react';
import JobCard from '../components/JobCard';
import SwipeControls from '../components/SwipeControls';
import MatchesList from '../components/MatchesList';
import { useToast } from "@/components/ui/use-toast";

export default function JobSwipeApp() {
  const [jobs, setJobs] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [matches, setMatches] = useState([]);
  const [loading, setLoading] = useState(true);
  const { toast } = useToast();
  
  // Simulating a logged-in user
  const currentUser = {
    id: 1,
    type: 'jobseeker'
  };

  useEffect(() => {
    fetchJobs();
    fetchMatches();
  }, []);

  const fetchJobs = async () => {
    try {
      setLoading(true);
      const response = await fetch('http://localhost:8080/api/jobs');
      const data = await response.json();
      setJobs(data);
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to load jobs. Please try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  const fetchMatches = async () => {
    try {
      const response = await fetch(`http://localhost:8080/api/matches?user_id=${currentUser.id}`);
      const data = await response.json();
      setMatches(data);
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to load matches. Please try again.",
        variant: "destructive",
      });
    }
  };

  const handleSwipe = async (direction) => {
    if (currentIndex >= jobs.length) return;

    try {
      await fetch('http://localhost:8080/api/swipe', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          job_id: jobs[currentIndex].id,
          jobseeker_id: currentUser.id,
          direction: direction
        }),
      });

      if (direction === 'right') {
        toast({
          title: "Interested!",
          description: "You've shown interest in this job.",
        });
        fetchMatches();
      }

      setCurrentIndex(prev => prev + 1);
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to record your choice. Please try again.",
        variant: "destructive",
      });
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-500"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <div className="max-w-4xl mx-auto space-y-8">
        <div className="bg-white rounded-xl shadow-lg overflow-hidden">
          {currentIndex < jobs.length ? (
            <>
              <JobCard job={jobs[currentIndex]} />
              <SwipeControls
                onSwipeLeft={() => handleSwipe('left')}
                onSwipeRight={() => handleSwipe('right')}
                disabled={currentIndex >= jobs.length}
              />
            </>
          ) : (
            <div className="p-8 text-center text-gray-600">
              No more jobs to review
            </div>
          )}
        </div>

        <MatchesList matches={matches} />
      </div>
    </div>
  );
}