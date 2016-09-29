#!/bin/bash
set +e
HOST=web1d

DESTDIR="/usr/share/nginx/html/static/demos/incident"
DESTDIRCONTENTS="/usr/share/nginx/html/static/demos/incident/*"
./clean-dependencies.sh
echo "Building app via polymer..."
polymer build || { exit 1; }
cd ./build/bundled
echo "Compressing bundle for transfer..."
tar -zcf ../incident.tar.gz .
cd ..
echo "Copying bundle to server..."
scp -i ~/.ssh/ICEsoft_Linux_Test_Key_Pair.pem incident.tar.gz ubuntu@web1d:~/. || { exit 1; }

echo "Unpacking bundle on server to $DESTDIR..."
ssh -i ~/.ssh/ICEsoft_Linux_Test_Key_Pair.pem ubuntu@web1d "sudo rm -r $DESTDIRCONTENTS && sudo tar -zxf /home/ubuntu/incident.tar.gz -C $DESTDIR && sudo chown -R www-data:www-data $DESTDIR"
echo "Cleaning up local compressed file..."
rm incident.tar.gz
cd ..
rm -rf build
