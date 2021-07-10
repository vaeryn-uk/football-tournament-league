USERID=$$(id -u)
RANDOMPASSWORD = $$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
ASSET_FILES=$(wildcard assets/css assets/js)
MIGRATION_FILES=$(wildcard **/migrations/0*.py)

.PHONY: up
up: .migrate .env
	docker-compose up web

.PHONY: test
test: .env
	docker-compose run --rm web python manage.py test

assets/built/app.js: makeflags/node_modules $(ASSET_FILES) .env
	docker-compose run --rm assets-builder node assets.build.js

node_modules: yarn.lock package.json .env
	docker-compose run --rm assets-builder sh -c 'yarn install'
	touch node_modules	# Update dir mtime so we don't need to run this again.

# Creates a Django admin superuser.
.PHONY: adminuser
adminuser: .migrate .env
	docker-compose run --rm web python manage.py createadminuser

# Generates new migrations after making model changes.
# Remember to run `make build` once you are happy with your migrations to apply them.
.PHONY: migrations
migrations: .env
	docker-compose run --rm web python manage.py makemigrations

.env: .env.dist
	cp .env.dist .env
	sed -i s/%USERID%/$(USERID)/ .env
	sed -i s/%MONGODBPASSWORD%/$(RANDOMPASSWORD)/ .env
	sed -i s/%MONGOADMINPASSWORD%/$(RANDOMPASSWORD)/ .env

# A local untracked file records when we last run migrations.
# Run again if a migration file changes.
.migrate: $(MIGRATION_FILES) .env
	docker-compose run --rm web python manage.py migrate
	touch .migrate

# Pins all dependencies to exact versions for subsequent pip installs.
# Should be run after adding any new dependencies to requirements.in.
# Builds the environment again ensuring that these requirements are installed.
.PHONY: pin-deps
pin-deps: .env
	docker-compose run --rm web pip-compile requirements.in
	docker-compose build web

.PHONY: clean
clean: .env	# Need .env for these docker-compose commands to function.
	docker-compose down --remove-orphans
	docker-compose rm -sf
	docker volume rm $$(docker volume ls -q | grep _mongo_db_data); echo "done"
	rm -rf .migrate
	rm -rf node_modules
	rm -rf .env