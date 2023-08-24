#!/bin/bash

# Default event type
EVENT_TYPE="echo"

# Function to display script usage
usage() {
  echo "Usage: $0 -o <repository_owner> -r <repository_name> -t <access_token> [-n <name>]"
  echo "  -o, --owner   GitHub repository owner."
  echo "  -r, --repo    GitHub repository name."
  echo "  -t, --token   Personal access token for authentication."
  echo "  -n, --name    Specify the name to be passed as an argument to the workflow (optional)."
  exit 1
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -o|--owner)
      REPO_OWNER="$2"
      shift # past argument
      shift # past value
      ;;
    -r|--repo)
      REPO_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -t|--token)
      TOKEN="$2"
      shift # past argument
      shift # past value
      ;;
    -n|--name)
      NAME="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      # unknown option
      usage
      ;;
  esac
done

# Check required parameters
if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ] || [ -z "$TOKEN" ]; then
  usage
fi

# Trigger the workflow using GitHub API
curl -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.everest-preview+json" \
  "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/dispatches" \
  -d "{\"event_type\": \"$EVENT_TYPE\", \"client_payload\": {\"name\": \"$NAME\"}}"

echo "Triggered workflow in repository $REPO_OWNER/$REPO_NAME with event type: $EVENT_TYPE and name: $NAME"
