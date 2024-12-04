# app.py
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

# Configure database connection using environment variables
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')
db = SQLAlchemy(app)

# Define database models
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    user_type = db.Column(db.String(20), nullable=False)  # 'recruiter' or 'jobseeker'

class Profile(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    title = db.Column(db.String(120), nullable=False)
    skills = db.Column(db.JSON)
    experience = db.Column(db.Integer)
    bio = db.Column(db.Text)

class Job(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    recruiter_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    title = db.Column(db.String(120), nullable=False)
    description = db.Column(db.Text)
    required_skills = db.Column(db.JSON)
    experience_required = db.Column(db.Integer)

class Match(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    job_id = db.Column(db.Integer, db.ForeignKey('job.id'), nullable=False)
    jobseeker_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    recruiter_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    status = db.Column(db.String(20), default='pending')  # pending, matched, rejected

# API Routes
@app.route('/api/jobs', methods=['GET'])
def get_jobs():
    """Get list of jobs for job seekers to swipe on"""
    jobs = Job.query.all()
    return jsonify([{
        'id': job.id,
        'title': job.title,
        'description': job.description,
        'required_skills': job.required_skills,
        'experience_required': job.experience_required
    } for job in jobs])

@app.route('/api/swipe', methods=['POST'])
def handle_swipe():
    """Handle job seeker swiping on a job"""
    data = request.json
    job_id = data['job_id']
    jobseeker_id = data['jobseeker_id']
    direction = data['direction']  # 'right' for interested, 'left' for pass
    
    if direction == 'right':
        job = Job.query.get(job_id)
        match = Match(
            job_id=job_id,
            jobseeker_id=jobseeker_id,
            recruiter_id=job.recruiter_id,
            status='pending'
        )
        db.session.add(match)
        db.session.commit()
        return jsonify({'message': 'Interest recorded'})
    
    return jsonify({'message': 'Passed'})

@app.route('/api/matches', methods=['GET'])
def get_matches():
    """Get matches for a user"""
    user_id = request.args.get('user_id')
    user = User.query.get(user_id)
    
    if user.user_type == 'jobseeker':
        matches = Match.query.filter_by(jobseeker_id=user_id).all()
    else:
        matches = Match.query.filter_by(recruiter_id=user_id).all()
    
    return jsonify([{
        'id': match.id,
        'job_id': match.job_id,
        'status': match.status
    } for match in matches])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
