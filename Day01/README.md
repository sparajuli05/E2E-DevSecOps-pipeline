You start with the **Local Workspace Setup.** Before you can automate anything in the cloud, your "Home Base" (your computer) needs the right tools to communicate with Docker, Kubernetes, and GitHub.

Here is **Step 1: Setting up your DevSecOps Command Center.**

----------

## **Step 1: The Command Center Setup**

A beginner needs to install the "Big Four" tools. These allow you to write code, package it, run it locally, and scan it for holes.

### **1. Install the Essential Tools**

**Tool**

**Purpose**

**Why for Beginners?**

**VS Code**

Code Editor

The industry standard with amazing plugins for Docker/K8s.

**Docker Desktop**

Containerization

Lets you turn your code into a "box" that runs anywhere.

**Git**

Version Control

The "Save Button" for your project. Essential for CI/CD.

**Trivy (CLI)**

Security Scanner

The easiest way to see "Security" in action immediately.

----------

## **Step 2: Create Your First "Vulnerable" Project**

We learn best by seeing things break and then fixing them.

1.  **Open VS Code** and create a folder named `sentinel-project`.
    
2.  **Create a file** named `app.js` (a simple web server):
    
    JavaScript
    
    ```
    const http = require('http');
    const server = http.createServer((req, res) => {
      res.end('Hello Secure World!');
    });
    server.listen(3000);
    
    ```
3.  **Initialize Git:** Open your terminal in VS Code and type:
    
    Bash
    
    ```
    git init
    
    ```
3.  **Install node:** Open your terminal in VS Code and type:
    
    Bash
    
    ```
    brew install node   //macos

    npm init -y

    or
    
    sudo apt update
    sudo apt install nodejs npm -y   //for linux/ubuntu

    npm init -y
    
    ```
    

----------

## **Step 3: The "Aha!" Moment (Your First Scan)**

This is the most important part of the first lesson. We will show the beginner that even a simple project can have security risks.

1.  **Create a standard (Insecure) Dockerfile** to see the difference:
    
    Dockerfile
    
    ```
    FROM node:latest
    COPY . .
    CMD ["node", "app.js"]
    
    ```
    
2.  **Build it:**
    
    Bash
    
    ```
    docker build -t my-first-app .
    
    ```
    
3.  **Scan it with Trivy:**
    
    Bash
    
    ```
    trivy image my-first-app
    
    ```
    

> [!CAUTION]
> 
> **What will happen:** The beginner will see a massive list of "CRITICAL" and "HIGH" vulnerabilities. This teaches them **why** we need the advanced pipeline we are about to build.

----------

## **Summary of the Lesson**

By the end of this "First Step," the beginner has:

-   Configured a professional environment.
    
-   Built their first container.
    
-   Understood that "Standard" is not "Secure."