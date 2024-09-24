# Choose base image, here select the smaller node:16-alpine version
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files into the container
COPY . .

# Expose application port
EXPOSE 8081

# Start the application
CMD ["npm", "start"]
