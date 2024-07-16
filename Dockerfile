# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and application to the working directory.
COPY ./app-src .

# Install Flask and other dependencies
RUN pip install --no-cache-dir -r requirment_modules.txt


# Expose the port on which Flask runs
EXPOSE 8080

# Command to run the Flask application
CMD ["python", "app.py"]