*This project has been created as part of the 42 curriculum by lhao.*

# Inception - System Administration with Docker

## Description
The **Inception** project is a System Administration exercise designed to deepen knowledge of containerization and service orchestration using Docker and Docker Compose. The goal is to build a secure, modular, and multi-container web infrastructure running on a Virtual Machine.

The stack consists of three dedicated services running in isolated containers:
- **NGINX**: The sole entrypoint to the infrastructure, listening strictly on port `443` with TLSv1.2 / TLSv1.3 protocols.
- **WordPress + PHP-FPM**: The CMS application backend processing dynamic PHP requests (without Nginx).
- **MariaDB**: The database management system storing WordPress site content and user data.

All services are built using custom Dockerfiles based on `debian:bookworm`, interconnected via a private Docker bridge network (`inception-net`), and supported by persistent Docker named volumes mapped to host directory paths (`/home/lhao/data/`).

---

## Instructions

### Prerequisites
- Docker (v20.10+) and Docker Compose (v2+).
- Map the target domain to localhost in your host `/etc/hosts` file:
  ```text
  127.0.0.1 lhao.42.fr
  ```
- An environment configuration file at `srcs/.env` containing database and WordPress credentials.

### Installation & Execution

#### 1. Build and Start the Infrastructure
From the root of the repository, execute:
```bash
make
```
This command creates host data directories, builds the custom Docker images, and launches all containers in detached mode (`-d`).

#### 2. Access the Website
Open your browser and navigate to:
- **WordPress Website:** `https://lhao.42.fr`
- **WordPress Admin Dashboard:** `https://lhao.42.fr/wp-admin`

*(Accept the browser security warning regarding the self-signed SSL certificate).*

#### 3. Stop the Infrastructure
```bash
make down
```

#### 4. Clean Up & Full Rebuild
To remove stopped containers, networks, images, and wipe persistent host volume data:
```bash
make fclean
```
To trigger a clean rebuild from scratch:
```bash
make re
```

---

## Project Description & Technical Choices

### Infrastructure Design Choices
- **Dedicated Container Per Service:** Each service (NGINX, WordPress, MariaDB) runs in its own isolated container without process managers like `supervisord` or infinite loop hacks (`tail -f`, `sleep infinity`).
- **TLS-Only Entrypoint:** NGINX handles SSL termination on port `443` only. Port `80` (HTTP) is not exposed to enforce HTTPS traffic.
- **Dynamic Configuration via `wp-cli`:** WordPress is automatically downloaded, configured, installed, and populated with two initial users (`lhao_admin` and `lhao_user`) upon first launch using `wp-cli`.

### Comparative Analysis

#### 1. Virtual Machines vs Docker Containers
- **Virtual Machines (VMs):** Virtualize an entire hardware stack and run a full guest operating system with its own kernel. They provide strong hardware-level isolation but suffer from high resource consumption, large disk footprints, and slow boot times.
- **Docker Containers:** Share the host operating system's kernel and isolate application processes at the OS level using Linux `namespaces` and `cgroups`. Containers are lightweight, start instantaneously, consume minimal RAM/CPU, and ensure consistent behavior across environments.

#### 2. Secrets vs Environment Variables
- **Environment Variables:** Configuration values passed into processes or defined in `.env` files. They are simple to use but can accidentally leak into shell histories, child processes, build logs, or `docker inspect` outputs.
- **Docker Secrets:** Secure mechanism for storing sensitive credentials (passwords, keys). Secrets are encrypted in transit/rest and mounted in-memory at `/run/secrets/` inside authorized containers only.
- **Usage in Inception:** Environment variables defined in `srcs/.env` pass parameters dynamically to Docker Compose while keeping credentials out of source control via `.gitignore`.

#### 3. Docker Network vs Host Network
- **Docker Network (Bridge Mode):** Creates a private, isolated virtual bridge namespace. Containers communicate securely using container/service names resolved by internal DNS, while only designated ports are published to the host.
- **Host Network (`--net=host`):** Bypasses container network isolation and attaches the container directly to the host machine's network interface. While it eliminates NAT performance overhead, it creates port conflicts and removes network isolation.

#### 4. Docker Volumes vs Bind Mounts
- **Docker Named Volumes:** Storage managed completely by Docker under `/var/lib/docker/volumes/`. They offer higher performance, decoupled lifecycle management (`docker volume`), and platform independence.
- **Bind Mounts:** Directly map a specific host directory into a container path. Useful for development live-reloading, but tightly couples container setup to the host's directory structure.
- **Usage in Inception:** Named local volumes with `driver_opts` (`type: none`, `o: bind`) are used to meet both Docker volume management requirements and host path persistence (`/home/lhao/data`).

---

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose V2 Specification](https://docs.docker.com/compose/)
- [NGINX Core Documentation](https://nginx.org/en/docs/)
- [WP-CLI Command Reference](https://developer.wordpress.org/cli/commands/)
- [MariaDB Server Knowledge Base](https://mariadb.com/kb/en/)

### AI Usage Disclosure
- **Diagnostic Analysis:** AI was utilized to analyze Docker build errors, shell wait loop bottlenecks, and permission issues.
- **Documentation Templates:** AI helped structure the comparative analysis and documentation format in accordance with 42 subject guidelines.
