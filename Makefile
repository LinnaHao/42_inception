COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_DIR = $(HOME)/data

all: up

up:
	@echo "Launching Inception..."
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "Stopping Inception..."
	docker compose -f $(COMPOSE_FILE) down -v

clean: down
	@echo "Cleaning up unused Docker images and containers..."
	docker system prune -af

fclean: clean
	@echo "Removing all data files and volumes..."
	rm -rf $(DATA_DIR)/mariadb
	rm -rf $(DATA_DIR)/wordpress
	docker volume prune -f

re: fclean all

.PHONY: all up down clean fclean re