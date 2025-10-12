# Use the official Python image as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the application files into the container
COPY . .

# Install necessary packages (curl + gnupg added)
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unixodbc \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft repository key (modern method)
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg

# Add Microsoft repository list
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Update and install MS ODBC driver
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Install Python dependencies
RUN pip install -r requirements.txt

# Start the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
