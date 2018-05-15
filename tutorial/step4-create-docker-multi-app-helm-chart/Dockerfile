# Environment integration Java8 + nginx
FROM jfrog.local:5000/kmonkeyjam/nginx-java8
# get the jar
RUN apt-get update
RUN apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_4.x | sudo bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential
RUN npm config set strict-ssl false
RUN npm install shelljs
COPY package /usr/share/nginx/html/frogsui/
RUN sed -i "s+http://localhost:9000/+/ws/+g" /usr/share/nginx/html/frogsui/app/app.js
COPY frogsws-0.1.0-*.jar /ws/frogsws.jar
COPY wrapper.sh /wrapper.sh
COPY ws.conf /etc/nginx/conf.d/ws.conf

EXPOSE 81 9000

CMD ["/wrapper.sh"]
