FROM python:3.11-slim

# Install system recon tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    whois \
    curl \
    dnsutils \
    git \
    perl \
    libnet-ssleay-perl \
    ruby \
    && git clone --depth 1 https://github.com/urbanadventurer/WhatWeb.git /opt/whatweb \
    && ln -s /opt/whatweb/whatweb /usr/local/bin/whatweb \
    && git clone --depth 1 https://github.com/sullo/nikto.git /opt/nikto \
    && ln -s /opt/nikto/program/nikto.pl /usr/local/bin/nikto \
    && apt-get purge -y git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Reports directory
RUN mkdir -p /app/reports

# Run as non-root user
RUN useradd -m -s /bin/bash metatron && \
    chown -R metatron:metatron /app
USER metatron

CMD ["python", "metatron.py"]
