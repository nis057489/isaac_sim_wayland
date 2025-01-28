# Use the NVIDIA Isaac Sim base image
FROM nvcr.io/nvidia/isaac-sim:4.2.0

# Install dependencies for VS Code
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    gpg \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft's GPG key and repository
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/vscode.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list

# Install VS Code
RUN apt-get update && apt-get install -y code

# (Optional) Set up a non-root user if necessary
# USER your_username

# Set the entrypoint or command as needed
# CMD ["bash"]
