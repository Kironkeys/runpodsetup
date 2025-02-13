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

# Secure Docker Login - User Inputs Token
echo "Enter your Docker Hub access token:"
read -s DOCKER_ACCESS_TOKEN
echo "$DOCKER_ACCESS_TOKEN" | docker login -u kironkeys --password-stdin

# Secure GitHub Authentication - User Inputs Token
echo "Enter your GitHub access token:"
read -s GITHUB_ACCESS_TOKEN
git clone https://$GITHUB_ACCESS_TOKEN@github.com/kironkeys/runpodsetup.git
cd runpodsetup

# Fix Docker Daemon Not Running Issue
echo "🔥 Starting Docker Service..."
systemctl start docker
systemctl enable docker

# Build Docker Image with Bazel
echo "🔥 Building Docker Image..."
bazel build //:docker_image
docker build -t keys-ai .

# Push Docker Image to Docker Hub
echo "🔥 Pushing Docker Image to Docker Hub..."
docker tag keys-ai kironkeys/keys-ai:latest
docker push kironkeys/keys-ai:latest

# Run AI Model in Docker
echo "🔥 Running AI Model..."
docker run -p 8000:8000 kironkeys/keys-ai:latest

echo "✅ Setup Complete! AI Model is running at http://62.169.158.149:8000"
