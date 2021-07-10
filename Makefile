USERID=$$(id -u)
RANDOMPASSWORD = $$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)

.PHONY: build
build: .env assets
	docker-compose build
	docker-compose run --rm web python manage.py migrate

.PHONY: up
up: build
	docker-compose up

.PHONY: assets
assets: assets-builder
	docker-compose run --rm assets-builder node assets.build.js

.PHONY: assets-builder
assets-builder:
	docker-compose build assets-builder
	docker-compose run --rm assets-builder sh -c 'yarn install'

# Creates a Django admin superuser.
.PHONY: adminuser
adminuser: build
	docker-compose run --rm web python manage.py createadminuser

# Generates new migrations after making model changes.
# Remember to run `make build` once you are happy with your migrations to apply them.
.PHONY: migrations
migrations: build
	docker-compose run --rm web python manage.py makemigrations

.env: .env.dist
	cp .env.dist .env
	sed -i s/%USERID%/$(USERID)/ .env
	sed -i s/%MONGODBPASSWORD%/$(RANDOMPASSWORD)/ .env
	sed -i s/%MONGOADMINPASSWORD%/$(RANDOMPASSWORD)/ .env

# Pins all dependencies to exact versions for subsequent pip installs.
# Should be run after adding any new dependencies to requirements.in.
# Builds the environment again ensuring that these requirements are installed.
.PHONY: pin-deps
pin-deps: build
	docker-compose run --rm web pip-compile requirements.in
	$(MAKE) build

.PHONY: clean
clean: .env	# Need .env for these docker-compose commands to function.
	docker-compose down --remove-orphans
	docker-compose rm -sf
	docker volume rm $$(docker volume ls -q | grep _mongo_db_data); echo "done"
	rm -rf .env