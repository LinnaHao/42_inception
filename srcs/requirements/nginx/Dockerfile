FROM debian:bookworm

# 1. 更新源，安装 nginx 和 openssl
RUN apt-get update && apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# 2. 生成自签名 SSL 证书 (有效天数 365 天)
# -subj 里面的参数可以随便写，符合 42 规范即可
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/inception.key \
    -out /etc/ssl/certs/inception.crt \
    -subj "/C=FR/ST=Île-de-France/L=Paris/O=42/CN=lhao.42.fr"

# 3. 复制我们写好的 Nginx 配置文件到系统默认的配置目录下
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# 4. 同时暴露 80 和 443 端口
EXPOSE 80 443

# 5. 前台运行 Nginx
CMD ["nginx", "-g", "daemon off;"]