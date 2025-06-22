#!/bin/bash

command="pod install --repo-update"

until $command; do
  echo "Command failed. Retrying..."
  sleep 1 # Optional: add a delay between retries
done

echo "Command succeeded."