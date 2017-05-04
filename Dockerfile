# Voyent Incident Demo

# This container is based on our Polymer Base image.  It then copies over
# and builds the app and sets it to be served via Nginx.

# The name:version of the Docker image to use.  Must be the first non-comment.
FROM voyent/base-polymer:latest

# The author of the image.
MAINTAINER ICEsoft Technologies, Inc.

# We'll put everything in a /work directory that we can later remove when everything
# is built and deployed.
RUN mkdir /work
WORKDIR /work

# Get all the stuff we need.
COPY images ./images
COPY src ./src
COPY *.js *.json *.html ./

# Install bower dependencies.
RUN ["bower", "--allow-root", "install"]

# Build the console with ember.
RUN ["polymer", "build"]

# Remove the Unix-y tools.
RUN apt-get remove -q -y curl xz-utils git-all

# Copy our custom nginx configurations.
COPY nginx.conf /etc/nginx/nginx.conf
COPY default /etc/nginx/conf.d/default.conf

# Copy the contents of the built version of the console so that nginx can serve it.
# A couple of notes.  After making the directory, we list it.  Seems to be a weird
# workaround to ensure that the director actually exists before we move stuff into
# it.  I was getting errors during the "mv" command otherwise.
RUN ["mkdir", "-p", "/usr/share/nginx/html/demos"]
RUN ["mv", "./build/bundled", "/usr/share/nginx/html/demos/incident"]

# Clean up by removing the work directory that has all the build artifacts.
WORKDIR /
RUN ["rm", "-Rf", "/work"]


