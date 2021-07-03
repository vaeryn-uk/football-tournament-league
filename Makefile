USERID=$$(id -u)

.PHONY: up
up: build
	docker-compose up

.PHONY: build
build: .env
	docker-compose build

.env:
	cp .env.dist .env
	sed -i s/%USERID%/$(USERID)/ .env

.PHONY: build
clean:
	docker-compose down
	rm -rf .env