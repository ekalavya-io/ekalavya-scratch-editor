# Stage 1: Build all workspaces
FROM --platform=$BUILDPLATFORM node:20-alpine AS build

RUN apk add --no-cache python3 g++ make cairo-dev pango-dev jpeg-dev giflib-dev

WORKDIR /app

COPY package*.json ./

RUN npm ci --legacy-peer-deps

COPY . .

# Build everything (this builds GUI, VM, renderers, etc.)
RUN npm run build

# Stage 2: Serve the Scratch GUI via Nginx
FROM --platform=$BUILDPLATFORM nginx:alpine

# Copy the built GUI (the web entry point)
COPY --from=build /app/packages/scratch-gui/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
