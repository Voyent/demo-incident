#!/bin/bash
set +e
HOST=web1d

echo "Updating from Git..."
git pull
echo "Removing old bower_components and build..."
rm -rf ./bower_components ./dist
echo "Installing new bower_components..."
bower install
