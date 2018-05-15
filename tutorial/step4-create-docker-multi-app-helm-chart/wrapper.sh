#!/bin/bash
nginx
java -jar /ws/frogsws.jar
npm start --prefix /usr/share/nginx/html/frogsui
