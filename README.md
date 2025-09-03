# Docker Clean & Rebuild Script

This script completely cleans all Docker resources (containers, images, volumes, networks, cache) and rebuilds your project's Docker images from scratch using `docker compose build --no-cache`.

Useful for ensuring a fresh, clean build without any cached layers or leftover data.

## ⚠️ Warning

This script will **delete all Docker containers, images, volumes, and networks** on your system.  
Only run it if you're sure you want to wipe all Docker data.

## 📦 Requirements

- Docker
- Docker Compose (either `docker compose` or `docker-compose`)
- Your `docker-compose.yml` file in the current directory

## ▶️ How to Use

1. **Make the script executable:**
   ```bash
   chmod +x clean-docker.sh
