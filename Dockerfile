
# Stage 1: Build the website with Node.js and Parcel
FROM node:22-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy dependency manifests first for layer caching
COPY package*.json ./

# Install exact dependencies from the lockfile
RUN npm ci

# Copy website source files
COPY src/ ./src/
COPY styles/ ./styles/

# Build all HTML pages into dist/
RUN npm run build

# Stage 2: Serve the generated static site with Nginx
FROM nginx:1.27-alpine

# Copy only production build output from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Document the HTTP port
EXPOSE 80

# Keep Nginx running in the foreground
CMD ["nginx", "-g", "daemon off;"]
