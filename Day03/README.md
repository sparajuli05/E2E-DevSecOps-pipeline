Here is the **Phase 3: The Automation Engine (GitHub Actions)** guide, formatted in Markdown. This is where we move from your local computer to the "Cloud" to make the security checks happen automatically.

----------

# Step 3: Automating the Pipeline with GitHub Actions

Now that your container is secure, you don't want to run `trivy scan` manually every time. We will use **GitHub Actions** to create an automated "security gate." If the code is insecure, the pipeline will fail and prevent deployment.

## 1. Create the Workflow Directory

GitHub looks for automation instructions in a specific hidden folder. In your project, create these folders:

Bash

```
mkdir -p .github/workflows

```

----------

## 2. Create the Pipeline File

Create a file named `.github/workflows/devsecops.yml` and paste the following code:

YAML

```
name: Sentinel-Flow-CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build-and-secure:
    runs-on: ubuntu-latest

    steps:
      # 1. Pull the code from GitHub
      - name: Checkout code
        uses: actions/checkout@v4

      # 2. Check for leaked secrets (API Keys)
      - name: Secret Scanning (Gitleaks)
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      # 3. Build the Secure Docker Image
      - name: Build Docker Image
        run: docker build -t sentinel-app:${{ github.sha }} .

      # 4. Run the Security Scan (Automated Trivy)
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'sentinel-app:${{ github.sha }}'
          format: 'table'
          exit-code: '1' # This stops the pipeline if a vulnerability is found!
          severity: 'CRITICAL,HIGH'

```

----------

## 3. How to Trigger the Automation

1.  **Push to GitHub:** Upload your code to a GitHub repository.
    
2.  **Watch the Magic:** Click on the **"Actions"** tab in your GitHub repo.
    
3.  **The Security Gate:** If your Dockerfile is still using `node:latest`, the **Trivy** step will turn **Red (Fail)**. If you use the **Multi-stage/Distroless** version we built in Step 2, it will turn **Green (Success)**.
    

----------

## 4. Summary & Key Concepts

**Concept**

**What it does for you**

**Triggers**

Automatically starts the scan every time you `git push`.

**Exit Code 1**

This is the "Gate." It stops the build if security flaws are found.

**GitHub Managed**

You don't need a server to run this; GitHub provides the compute for free.