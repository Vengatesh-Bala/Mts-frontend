# Step 1: Build React app
FROM node:18 AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the project and build
COPY . .
RUN npm run build

# Step 2: Serve with Nginx
FROM nginx:alpine

# Copy custom Nginx config (for port 9000)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build files to nginx html folder
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 9000
CMD ["nginx", "-g", "daemon off;"]
