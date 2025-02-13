#!/bin/bash

echo "🔥 Starting Full Setup..."

# Update & Install Dependencies (No Sudo Needed)
apt update && apt install -y curl gnupg unzip build-essential openjdk-11-jdk git awscli

# Install Bazel
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor -o /usr/share/keyrings/bazel-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list
apt update && apt install -y bazel

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Log into Docker Hub (Using Your Token)
echo "🔥 Logging into Docker Hub..."
echo "dckr_pat_42-ra0__ArBmldgvD3tXb7cCmtc" | docker login -u kironkeyz --password-stdin

# Clone AI Repository
echo "🔥 Cloning GitHub Repository..."
git clone https://github.com/kironkeyz/runpodsetup.git && cd runpodsetup

# Build Docker Image with Bazel
echo "🔥 Building Docker Image..."
bazel build //:docker_image
docker build -t keys-ai .

# Push Docker Image to Docker Hub
echo "🔥 Pushing Docker Image to Docker Hub..."
docker tag keys-ai kironkeyz/keys-ai:latest
docker push kironkeyz/keys-ai:latest

# Run AI Model in Docker
echo "🔥 Running AI Model..."
docker run -p 8000:8000 kironkeyz/keys-ai:latest

echo "✅ Setup Complete! AI Model is running at http://62.169.158.149:8000"
