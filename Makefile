SHELL		= bash
COMPOSE		= srcs/docker-compose.yml
REQ_DIR		= srcs/requirements
VOL_DIR		= ~/data
DIR_LIST	= nginx wordpress mariadb
DCOMPOSE	= docker compose -f $(COMPOSE)
NGINX_DIR	= $(REQ_DIR)/nginx
NGINX_FILES	= $(wildcard $(NGINX_DIR)/*)

all: nginx wordpress mariadb
	$(DCOMPOSE) up -d #--build

nginx: $(NGINX_DIR) $(NGINX_FILES)
	$(DCOMPOSE) up -d $@

clean:
	$(DCOMPOSE) down --rmi all

fclean: clean
	sudo rm -rf $(VOL_DIR)/mariadb/* $(VOL_DIR)/wordpress/* $(REQ_DIR)/nginx/logs/* $(REQ_DIR)/wordpress/logs/*

enter:
	-$(DCOMPOSE) exec -it $(a) $(SHELL)

ps:
	$(DCOMPOSE) ps

logs:
	$(DCOMPOSE) logs

re:	clean all

reset: fclean all

.PHONY: all clean fclean enter ps logs re reset
#COMPOSE_PROJECT_NAME= $(shell grep "COMPOSE_PROJECT_NAME" srcs/.env | cut -c 22-24)
