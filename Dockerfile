# Start with a Python 2.7 base image
FROM python:2.7

# Set the working directory in the container
WORKDIR /app

# Install Node.js
# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get -y autoclean

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.13.0

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Confirm Node.js and npm are installed
RUN node -v
RUN npm -v

# Install Gulp globally inside the container
RUN npm i -g gulp@3.9.1

# Set up quality of life improvements. Add to all users.
RUN echo "alias ll='ls -la'" >> /etc/bash.bashrc

# Copy the project files into the container at /app
COPY . .

# Install any needed packages specified in package.json
RUN npm install

# Build the AngularJS application
RUN npm run build || exit 1

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run the app when the container launches
CMD ["npm", "run", "dev"]
