FROM nginx:alpine

COPY packages/scratch-gui/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
