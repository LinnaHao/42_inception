# Developer Documentation - Inception Infrastructure

## 1. Development Environment Setup
1. Clone the repository.
2. Ensure `srcs/.env` exists with your environment variables:
   ```env
   DOMAIN_NAME=lhao.42.fr
   MYSQL_HOSTNAME=mariadb
   MYSQL_DATABASE=wordpress
   MYSQL_USER=lhao
   MYSQL_PASSWORD=user_password123
   MYSQL_ROOT_PASSWORD=root_password123

   WP_TITLE=Inception
   WP_ADMIN_USER=lhao_admin
   WP_ADMIN_PASSWORD=admin_password123
   WP_ADMIN_EMAIL=lhao_admin@student.42.fr

   WP_USER=lhao_user
   WP_PASSWORD=sub_password123
   WP_EMAIL=lhao_user@student.42.fr
   ```

---

## 2. Architecture & Service Management

### Container Services
- **`nginx`**: Listens on host port `443`. Forwards PHP requests to `wordpress:9000` over `inception-net`.
- **`wordpress`**: Runs PHP-FPM 8.2 on port `9000`. Executes `entrypoint.sh` on startup to auto-download and configure WordPress via `wp-cli`.
- **`mariadb`**: Listens on port `3306`. Runs `entrypoint.sh` to initialize database schemas and user grants.

### Common Management Commands
- View container logs: `docker logs <container_name>`
- Shell access: `docker exec -it <container_name> /bin/bash`
- List volumes: `docker volume ls`

---

## 3. Data Persistence & Storage
Data is persisted using Docker local named volumes mapped to host directory paths:
- **WordPress Web Files:** `${HOME}/data/wordpress` mapped to `/var/www/html`
- **MariaDB Database:** `${HOME}/data/mariadb` mapped to `/var/lib/mysql`

Even if containers are stopped or recreated (`make down` / `make`), all site data, uploaded media, and database tables remain stored on the host filesystem.
