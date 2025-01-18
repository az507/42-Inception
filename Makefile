all:
	docker compose -f srcs/docker-compose.yml -p proj up

fclean:
	docker compose -f srcs/docker-compose.yml -p proj stop

re:	fclean all
