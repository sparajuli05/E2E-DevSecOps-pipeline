# --- STAGE 1: Build Stage ---
# We use a standard image to install our dependencies
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency files first for better caching
COPY package*.json ./
RUN npm install --only=production

# Copy the rest of your application code
COPY . .

# --- STAGE 2: Runtime Stage ---
# We use "Distroless" - it has no shell or extra tools for hackers to use
FROM gcr.io/distroless/nodejs20-debian12

# Set the environment to production
ENV NODE_ENV=production

WORKDIR /app

# Copy ONLY the necessary files from the builder stage
COPY --from=builder /app /app

# Run as a non-root user (built into distroless) for safety
USER nonroot

# Start the application
CMD ["app.js"]