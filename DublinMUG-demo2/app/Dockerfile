FROM node
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ./node-todo-demo ./
RUN npm install
CMD ["node", "server.js"]
