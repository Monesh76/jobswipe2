import React from 'react';
import { Badge } from '@/components/ui/badge';

const JobCard = ({ job }) => {
  return (
    <div className="bg-white p-6 rounded-xl shadow-lg">
      <div className="mb-4">
        <h2 className="text-2xl font-bold text-gray-800">{job.title}</h2>
        <p className="text-sm text-gray-500">{job.company}</p>
      </div>
      
      <div className="mb-4">
        <p className="text-gray-700">{job.description}</p>
      </div>
      
      <div className="mb-4">
        <h3 className="font-semibold mb-2">Required Skills:</h3>
        <div className="flex flex-wrap gap-2">
          {job.required_skills.map((skill, index) => (
            <Badge key={index} variant="secondary">
              {skill}
            </Badge>
          ))}
        </div>
      </div>
      
      <div className="flex justify-between items-center">
        <span className="text-sm text-gray-600">
          {job.experience_required} years experience
        </span>
        <span className="text-sm text-gray-600">
          {job.location}
        </span>
      </div>
    </div>
  );
};

export default JobCard;