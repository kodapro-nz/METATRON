FROM python:3.11-slim

# Install system recon tools and MariaDB client
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    whois \
    whatweb \
    curl \
    dnsutils \
    nikto \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Reports directory
RUN mkdir -p /app/reports

CMD ["python", "metatron.py"]
