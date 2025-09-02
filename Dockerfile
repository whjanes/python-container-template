FROM python:3.11-slim

# Install Microsoft ODBC Driver 18 for SQL Server (Debian 12 fix with signed-by)
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    unixodbc \
    unixodbc-dev \
    gcc \
 && mkdir -p /usr/share/keyrings \
 && curl -sSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    -o /usr/share/keyrings/microsoft-prod.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Jupyter
RUN pip install notebook jupyter-server

# Copy app source code
COPY . .

# Expose Jupyter port
EXPOSE 8888

# Start Jupyter Server
CMD ["jupyter", "server", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=''"]
