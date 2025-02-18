FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    sudo \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create test user
RUN useradd -m testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy setup script and set permissions before switching user
COPY setup.sh /home/testuser/
RUN chown testuser:testuser /home/testuser/setup.sh && \
    chmod +x /home/testuser/setup.sh

# Switch to test user
USER testuser
WORKDIR /home/testuser

# For testing the script
CMD ["./setup.sh"]
