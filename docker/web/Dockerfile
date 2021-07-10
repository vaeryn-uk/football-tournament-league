# Adapted from https://docs.docker.com/samples/django/
FROM python:alpine

RUN apk add build-base


# Do not buffer python output. Allows for real-time container logs.
ENV PYTHONUNBUFFERED=1
# Create a user mirroring the host user.
ARG UID
RUN adduser -u $UID -D dev
USER $UID

RUN pip install pip-tools

WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt

# Update path with user local (where python binaries are installed)
ENV PATH="${PATH}:/home/dev/.local/bin"