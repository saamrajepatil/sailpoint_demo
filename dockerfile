FROM ubuntu:latest

# Update the package lists and install required packages
RUN apt-get update && \
    apt-get install -y curl jq bash

# Set the working directory
WORKDIR /app

# Copy the script file to the container
COPY script.sh .

# Make the script executable
RUN chmod +x script.sh

# Define the entry point for the container
ENTRYPOINT ["/bin/bash", "/app/script.sh"]
