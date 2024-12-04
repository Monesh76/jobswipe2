import React from 'react';
import {
  Card,
  CardHeader,
  CardTitle,
  CardContent,
} from "@/components/ui/card";

const MatchesList = ({ matches }) => {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Your Matches</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          {matches.map((match) => (
            <div 
              key={match.id} 
              className="flex items-center justify-between p-3 bg-gray-50 rounded-lg"
            >
              <div>
                <h3 className="font-medium">{match.job.title}</h3>
                <p className="text-sm text-gray-600">{match.job.company}</p>
              </div>
              <span className={`px-2 py-1 rounded text-sm ${
                match.status === 'matched' 
                  ? 'bg-green-100 text-green-800'
                  : 'bg-yellow-100 text-yellow-800'
              }`}>
                {match.status}
              </span>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
};

export default MatchesList;