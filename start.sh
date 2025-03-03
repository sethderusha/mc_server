#!/bin/bash

WORLD_NAME="world"   # Change if your world has a different name
JAR_FILE="server.jar"  # Change to your actual server jar file

# Get the script's directory (assumed to be the server and repo directory)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR"

# Pull latest changes from GitHub
echo "Pulling latest world backup..."
git pull origin main  # Change branch if necessary
cp -r "$WORLD_NAME" "$SCRIPT_DIR"

# Start the server in a new screen session (requires 'screen' package)
screen -dmS minecraft java -Xms2G -Xmx4G -jar "$JAR_FILE" nogui

echo "Server started. Type 'stop' to stop the server and save progress."

while true; do
    read -r input
    if [[ "$input" == "stop" ]]; then
        screen -S minecraft -X stuff "save-all\n"
        sleep 2
        screen -S minecraft -X stuff "stop\n"
        sleep 10
        break
    fi
done

# Backup world and commit to GitHub
echo "Backing up world..."
git add "$WORLD_NAME"
git commit -m "Auto-save: $(date)"
git push origin main  # Change branch if necessary

echo "Backup complete!"

