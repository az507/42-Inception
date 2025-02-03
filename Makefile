SHELL		= bash
COMPOSE		= srcs/docker-compose.yml
REQ_DIR		= srcs/requirements
VOL_DIR		= ~/data
DCOMPOSE	= docker compose -f $(COMPOSE)

all:
	mkdir -p $(VOL_DIR)/mariadb $(VOL_DIR)/wordpress
	$(DCOMPOSE) up -d

clean:
	$(DCOMPOSE) down #--rmi all

fclean:
	$(DCOMPOSE) down --rmi all
	rm -rf $(VOL_DIR)/mariadb $(VOL_DIR)/wordpress

enter:
	-$(DCOMPOSE) exec -it $(c) $(SHELL)

ps:
	$(DCOMPOSE) ps $(c)

logs:
	$(DCOMPOSE) logs $(c)

re:	clean all

reset: fclean all

.PHONY: all clean fclean enter ps logs re reset
