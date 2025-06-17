.PHONY: up down build-redis-proxy

up: 
	docker-compose up -d

down:
	docker-compose down

build-redis-proxy:
	docker build -t upstash-local:latest ./upstash_redis