# Use Python 3.11 slim image for a smaller footprint
FROM python:3.11-slim

# Set working directory in the container
WORKDIR /app

# Install system dependencies required for psycopg2
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better cache utilization
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY src/ .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Expose the port the app runs on
EXPOSE 8080

# Run the application with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "4", "app:app"]