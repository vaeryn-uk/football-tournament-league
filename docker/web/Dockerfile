# Adapted from https://docs.docker.com/samples/django/
FROM python:alpine

# Create a user mirroring the host user.
ARG UID
RUN adduser -u $UID -D dev
USER $UID

# Do not buffer python output. Allows for real-time container logs.
ENV PYTHONUNBUFFERED=1

WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt

# Update path with user local (where python binaries are installed)
ENV PATH="${PATH}:/home/dev/.local/bin"