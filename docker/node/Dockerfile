FROM node:alpine

# Create a user mirroring the host user.
ARG UID
RUN adduser -u $UID -D dev || echo "User already exists"
USER $UID