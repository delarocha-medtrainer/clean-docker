#!/bin/bash

echo "========================================"
echo "    FULL DOCKER CLEANUP SCRIPT"
echo "    ⚠️  WARNING: This will remove"
echo "    all containers, images,"
echo "    volumes, networks, and cache."
echo "========================================"
read -p "Are you sure? (y/N): " confirm
echo ""

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "❌ Operation cancelled."
  exit 0
fi

echo "🚀 Starting Docker cleanup..."

# 1. Stop all running containers
echo "⏹️  Stopping all running containers..."
docker kill $(docker ps -q) 2>/dev/null || echo "➡️  No running containers found."

# 2. Remove all containers
echo "🗑️  Removing all containers..."
docker rm -f $(docker ps -a -q) 2>/dev/null || echo "➡️  No containers to remove."

# 3. Remove all images
echo "🔥 Removing all Docker images..."
docker rmi -f $(docker images -q) 2>/dev/null || echo "➡️  No images to remove."

# 4. Remove all volumes
echo "💥 Removing all volumes (persistent data will be lost)..."
docker volume rm -f $(docker volume ls -q) 2>/dev/null || echo "➡️  No volumes to remove."

# 5. Remove custom networks
echo "🔌 Removing custom networks..."
docker network rm $(docker network ls -q --filter type=custom) 2>/dev/null || echo "➡️  No custom networks to remove."

# 6. Prune system (cache, build layers, etc.)
echo "🧼 Cleaning build cache and unused data..."
docker system prune -a --volumes --force

# ✅ NEW: Build images with Docker Compose (no cache)
echo "🛠️  Building images with 'docker compose build --no-cache'..."
if command -v docker-compose &> /dev/null; then
  # Support for old 'docker-compose'
  docker-compose build --no-cache
elif docker compose &> /dev/null; then
  # Support for new 'docker compose' (plugin)
  docker compose build --no-cache
else
  echo "❌ Neither 'docker compose' nor 'docker-compose' was found."
  echo "➡️  Please make sure Docker Compose is installed."
  exit 1
fi

echo ""
echo "✅ Cleanup and rebuild complete!"
echo "➡️  Run 'docker compose up' to start your services."
