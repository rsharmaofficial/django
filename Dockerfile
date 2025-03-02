# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Set the working directory in the container
WORKDIR /app/backend

# Install system dependencies and Python 3.8
RUN yum update -y && \
    yum install -y \
    gcc \
    mariadb-devel \
    libpq-devel \
    libffi-devel \
    openssl-devel \
    python3 \
    python3-pip \
    python3-devel \
    && yum clean all

# Verify Python version
RUN python3 --version

# Ensure pip is up-to-date
RUN python3 -m pip install --upgrade pip

# Copy the requirements file first for caching
COPY requirements.txt /app/backend/

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the container
COPY . /app/backend

# Expose port 8000 for Django
EXPOSE 8000

# Run migrations and start the Django app
CMD ["sh", "-c", "python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000"]
