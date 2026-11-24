FROM nginxinc/nginx-unprivileged:1.27-alpine

USER root

# The repository ships a prebuilt browser bundle (index.html, index.js, doom*.js,
# doom*.wasm, doom*.data) under public/. Serve it as static files.
RUN apk --no-cache upgrade

RUN cat <<'EOF' > /etc/nginx/conf.d/default.conf
server {
    listen 8080;
    listen [::]:8080;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

COPY --chown=101:101 public/ /usr/share/nginx/html/

USER 101

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
