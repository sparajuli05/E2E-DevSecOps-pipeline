Since we’ve set up the "Insecure" version and seen the vulnerabilities, the next logical step for a beginner is learning how to **fix them**.

In 2026, the industry standard for this is the **Multi-Stage Build** using **Distroless** images. This reduces your "attack surface" (the parts of your app a hacker can touch).

Here is **Step 2: Hardening the Container**, formatted in Markdown for your guide.

----------

# Step 2: Hardening the Container (The "Secure" Way)

In Step 1, we saw that `node:latest` is full of security holes. Now, we will use **Advanced Automation Techniques** to build a tiny, secure, production-ready image.

## 1. The Strategy: Multi-Stage Builds

We will split our Dockerfile into two parts:

1.  **The Builder:** A heavy image that installs all our tools and dependencies.
    
2.  **The Runtime:** A tiny, "Distroless" image that contains **only** our application and nothing else (no shell, no package manager, no extra tools).
    

----------

## 2. Create the Secure Dockerfile

Replace the content of your `Dockerfile` with the following code:

Dockerfile

```
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

```

----------

## 3. Build and Verify the "Secure" Version

Now, let's compare the results.

### **A. Build the Secure Image**

Bash

```
docker build -t secure-app:v1 .

```

### **B. Run the Security Scan Again**

Bash

```
trivy image secure-app:v1

```

> [!TIP]
> 
> **Observation:** You should see the vulnerability count drop significantly—often to **zero** or just a few minor items. This is "Security-by-Design."

----------

## 4. Why This Works (The "Beginner" Logic)

**Feature**

**Why we do it**

**`AS builder`**

Keeps the final image small by leaving behind build tools.

**Distroless Base**

If a hacker gets in, they can't run commands like `ls`, `cd`, or `curl`.

**`USER nonroot`**

Even if the app is hacked, the attacker cannot change system settings.

----------

## 5. Summary of Step 2

You have successfully:

1.  Implemented a **Multi-Stage Build**.
    
2.  Used a **Distroless** image to eliminate 90% of your security risks.
    
3.  Proved the fix using **Trivy**.