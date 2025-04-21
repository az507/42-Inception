# Inception

> A containerized web infrastructure project using **Docker** and **Docker Compose**, built from scratch for the 42 School curriculum.

## Project Description

**Inception** is a DevOps-focused system administration project designed to introduce students to containerization, infrastructure-as-code, and the basics of managing production-grade services using **Docker**.

The goal is to build a secure, modular web infrastructure that runs multiple services in isolated **Docker containers**. The project focuses on:
- Configuring services using Dockerfiles
- Using **Docker Compose** to manage orchestration
- Implementing persistent volumes
- Generating and configuring **SSL certificates**
- Managing inter-container networking
- Creating custom images and secure environments

---

## Project Goals

- Build a full containerized WordPress website
- Configure NGINX as a secure reverse proxy
- Set up a MariaDB database with user-level access
- Implement HTTPS with **OpenSSL**
- Use **Docker volumes** for data persistence
- Isolate services into separate containers
- Deploy the stack using **Docker Compose**

## Usage
> Note: dynamically generated .env file (with arbitrary values) just for testing/development
```bash
git clone https://github.com/az507/42-Inception.git
cd 42-Inception
make
# Access the wordpress site at https://localhost
```
