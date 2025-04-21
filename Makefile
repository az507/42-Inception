SHELL		= bash
COMPOSE		= srcs/docker-compose.yml
REQ_DIR		= srcs/requirements
VOL_DIR		= ~/data
DCOMPOSE	= docker compose -f $(COMPOSE)

all: srcs/.env
	mkdir -p $(VOL_DIR)/mariadb $(VOL_DIR)/wordpress
	$(DCOMPOSE) up --build -d

srcs/.env:
	@echo "Creating .env file now"
	@echo "HOSTNAME=localhost" >> srcs/.env
	@echo "DB_NAME=wordpress" >> srcs/.env
	@echo "DB_USER=dbuser" >> srcs/.env
	@echo "USER_NAME=user123" >> srcs/.env
	@echo "USER_EMAIL=asdfake@gmail.com" >> srcs/.env
	@echo "ADMIN_USER=asd" >> srcs/.env
	@echo "ADMIN_NAME=someone" >> srcs/.env
	@echo "ADMIN_EMAIL=normal@gmail.com" >> srcs/.env
	@echo "WEBSITE_URL=localhost" >> srcs/.env
	@echo "WEBSITE_TITLE=title" >> srcs/.env
	@echo "COMPOSE_PROJECT_NAME=srcs" >> srcs/.env
	@mkdir -p secrets
	@echo pass123 > secrets/admin_password.txt
	@echo qwea123 > secrets/user_password.txt
	@echo db123 > secrets/db_password.txt
	@echo dbpass123 > secrets/db_root_password.txt
	@echo redis123 > secrets/redis_auth.txt
	@openssl genrsa -out secrets/ssl_cert_key.txt
	@openssl req -new -key secrets/ssl_cert_key.txt -out secrets/ssl_cert_req.txt \
		-subj "/C=SG/CN=www.example.com" 
	@openssl x509 -req -in secrets/ssl_cert_req.txt -signkey secrets/ssl_cert_key.txt \
 		-subj "/C=SG/CN=www.example.com" \
		-out secrets/ssl_cert.txt -days 365

clean:
	$(DCOMPOSE) down #--rmi all

fclean:
	$(DCOMPOSE) down --volumes --rmi all --timeout 2
	sudo rm -rf $(VOL_DIR) secrets srcs/.env

enter:
	-$(DCOMPOSE) exec -it $(c) $(SHELL)

ps:
	$(DCOMPOSE) ps $(c)

logs:
	$(DCOMPOSE) logs $(c)

re:	clean all

reset: fclean all

.PHONY: all clean fclean enter ps logs re reset
