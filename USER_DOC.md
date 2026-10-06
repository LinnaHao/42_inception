# User Documentation - Inception Infrastructure

## 1. Overview of Provided Services
This infrastructure provides a secure, self-hosted WordPress web stack:
- **NGINX:** Reverse proxy and TLS entrypoint listening on port 443 (HTTPS).
- **WordPress + PHP-FPM:** Content Management System (CMS) backend processing dynamic PHP requests.
- **MariaDB:** Relational database storing WordPress site data, pages, and users.

---

## 2. Starting and Stopping the Project

### Start the infrastructure:
```bash
make
```

### Stop the infrastructure:
```bash
make down
```

### Completely reset and rebuild the infrastructure:
```bash
make re
```

---

## 3. Accessing the Website & Admin Panel

1. Ensure your host machine `/etc/hosts` contains:
   ```text
   127.0.0.1 lhao.42.fr
   ```
2. Open your browser and navigate to:
   - **Public Website:** `https://lhao.42.fr`
   - **Admin Panel:** `https://lhao.42.fr/wp-admin`

*(Accept the browser security warning regarding the self-signed SSL certificate).*

---

## 4. Managing Credentials
All sensitive credentials are stored locally in `srcs/.env`:
- **WordPress Admin User:** `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD`
- **WordPress Author User:** `WP_USER` / `WP_PASSWORD`
- **MariaDB Root Password:** `MYSQL_ROOT_PASSWORD`
- **Database User Password:** `MYSQL_PASSWORD`

---

## 5. Checking Service Status
To verify that all services are running properly:
```bash
docker compose -f srcs/docker-compose.yml ps
```
To view logs for troubleshooting:
```bash
docker compose -f srcs/docker-compose.yml logs -f
```
