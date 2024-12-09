# THis one is used
# Use the official Dart SDK image
FROM dart:stable

# Set the working directory inside the container
WORKDIR /app

# Copy pubspec files to cache dependencies
COPY myminipod_server/pubspec.* /app/

# Install dependencies
RUN dart pub get

# Copy everything from the myminipod_server directory
COPY myminipod_server/ /app/

# Check Dart installation
RUN dart --version

# Check if the file paths are correct and 'main.dart' exists
RUN ls -al /app/bin/

# Attempt to compile the Dart application into an executable
RUN dart compile exe /app/bin/main.dart -o /app/server

# Expose port 8080
EXPOSE 8080

# Run the compiled server executable
CMD ["./server"]
