# Use Python base image from Docker Hub
FROM python:latest

# Set working directory inside the container
WORKDIR /app

# Copy all project files into the container
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose the Flask application port
EXPOSE 8080

# Start the application
ENTRYPOINT ["python"]
CMD ["app.py"]