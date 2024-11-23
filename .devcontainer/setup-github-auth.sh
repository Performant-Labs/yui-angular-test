#!/bin/bash

echo "Setting up GitHub access for HTTPS..."

# Ask the user for their GitHub username and PAT/token or password
read -p "GitHub Username: " github_username
read -s -p "GitHub Personal Access Token (PAT) or Password: " github_token
echo ""

# Configure Git to use the provided credentials
git config --global credential.helper store
echo "https://${github_username}:${github_token}@github.com" > ~/.git-credentials

# Test GitHub authentication
echo "Testing authentication with GitHub..."
git ls-remote https://github.com/org-name/repo-name.git > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "GitHub authentication successful!"
else
    echo "Authentication failed. Please check your credentials."
    exit 1
fi
