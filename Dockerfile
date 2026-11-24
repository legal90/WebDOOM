# syntax=docker/dockerfile:1

# Stage 1: compile WebDOOM to WebAssembly with Emscripten using the repo's own build.sh.
FROM emscripten/emsdk:3.1.38 AS build
WORKDIR /src
COPY . .
RUN chmod +x build.sh && ./build.sh doom1 \
 && cp build/web/doom1.html build/web/index.html

# Stage 2: serve the static output (HTML, JS, WASM, data files) over HTTP.
FROM nginx:1.27-alpine
COPY --from=build /src/build/web /usr/share/nginx/html
EXPOSE 80
