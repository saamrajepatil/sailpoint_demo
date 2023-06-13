#!/bin/bash

# GitHub API endpoint
API_URL="https://api.github.com"

# GitHub repository details
REPO_OWNER="saamrajepatil"
REPO_NAME="hello-world"

# Email details
FROM="sender@example.com"
TO="recipient@example.com"
SUBJECT="Pull Request Summary Report"
BODY=""

# Retrieve the list of pull requests
pull_requests=$(curl -s "${API_URL}/repos/${REPO_OWNER}/${REPO_NAME}/pulls?state=all")

# Initialize counters
opened_count=0
closed_count=0
in_progress_count=0

# Loop through each pull request
# Loop through each pull request
for pr in $(echo "$pull_requests" | jq -r '.[] | @base64'); do
    pull_request=$(echo "$pr" | base64 --decode)
    pr_title=$(echo "$pull_request" | jq -r '.title')
    pr_state=$(echo "$pull_request" | jq -r '.state')
    pr_created_at=$(echo "$pull_request" | jq -r '.created_at')
    pr_updated_at=$(echo "$pull_request" | jq -r '.updated_at')
    pr_closed_at=$(echo "$pull_request" | jq -r '.closed_at')

    # Get the timestamp for 7 days ago
    week_ago=$(date -d "7 days ago" +%s)

    # to get week start time
    week_=$(date -d "7 days ago")
    # Check if the pull request was created, closed, or updated in the last 7 days
    if [[ "$(date -d "$pr_created_at" +%s)" -ge "$week_ago" || \
          "$(date -d "$pr_closed_at" +%s)" -ge "$week_ago" || \
          "$(date -d "$pr_updated_at" +%s)" -ge "$week_ago" ]]; then
        case $pr_state in
            "open") ((opened_count++)) ;;
            "closed" | "merged") ((closed_count++)) ;;
            *) ((in_progress_count++)) ;;
        esac

        # Add pull request details to the email body
        BODY+="Title: $pr_title\n"
        BODY+="State: $pr_state\n"
        BODY+="Created at: $pr_created_at\n"
        BODY+="Updated at: $pr_updated_at\n"
        BODY+="Closed at: $pr_closed_at\n"
        BODY+="\n---\n"  # Horizontal line separator
    fi
done


# Remove trailing separator if any
BODY=${BODY%"\n---\n"}

# Generate the email content
EMAIL_CONTENT="From: $FROM\n"
EMAIL_CONTENT+="To: $TO\n"
EMAIL_CONTENT+="Subject: $SUBJECT starting from $week_\n"
EMAIL_CONTENT+="\n"
EMAIL_CONTENT+="Pull Request Summary for Repository: $REPO_OWNER/$REPO_NAME\n"
EMAIL_CONTENT+="\n"
EMAIL_CONTENT+="Opened: $opened_count\n"
EMAIL_CONTENT+="Closed: $closed_count\n"
EMAIL_CONTENT+="In Progress: $in_progress_count\n"
EMAIL_CONTENT+="\n"
EMAIL_CONTENT+="Details:\n"
EMAIL_CONTENT+="$BODY"

# Print the email details
echo -e "$EMAIL_CONTENT"
