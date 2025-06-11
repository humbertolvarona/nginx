# nginx

# 🚀 Nginx + PHP 8.3 Alpine Container

![Docker](https://img.shields.io/badge/Docker-ready-blue)
![Alpine](https://img.shields.io/badge/Base-Alpine%203.21-29abe2)
![License](https://img.shields.io/badge/License-MIT-green)
![Build](https://img.shields.io/badge/PHP-8.3-blueviolet)
![NGINX](https://img.shields.io/badge/Nginx-modular%20build-yellow)

[![Docker badge](https://img.shields.io/badge/Docker-Ready-3a88fe?style=for-the-badge&logo=docker)](https://hub.docker.com/)
[![Docker badge](https://img.shields.io/badge/Docker-ready-00c7fc?style=plastic&logo=docker)](https://hub.docker.com/)
![Docker badge](https://img.shields.io/badge/Docker-ready-00c7fc?style=plastic&logo=docker)

---

## 📆 Summary

A lightweight, secure, and dynamic container image based on **Alpine 3.21**, featuring:

- 🔥 **Nginx** with 15+ production modules
- 🐘 **PHP 8.3-FPM** with full extension support
- 🔐 **Automatic HTTPS** (via self-signed certs)
- ⚙️ **Runtime config** via environment variables
- ❤️‍🩹 Integrated **healthcheck**, time zone sync, and log diagnostics

---

## 📊 Build Info

| Parameter         | Value                 |
|------------------|------------------------|
| Base Image        | `alpine:3.21`          |
| Nginx Version     | Configurable via `ARG` |
| PHP Version       | PHP 8.3 + extensions   |

---

## 🧰 Environment Variables

| Variable                | Description                                                | Default   |
|-------------------------|------------------------------------------------------------|-----------|
| `TIMEZONE`              | System timezone (linked to `/etc/localtime`)              | `UTC`     |
| `PHP_MEMORY_LIMIT`      | PHP memory limit applied via FPM and `php.ini`            | `512M`    |
| `NGINX_WORKER_PROCESSES`| Controls Nginx concurrency                                | `1`       |
| `REDIRECT_TO_HTTPS`     | Enables HTTP to HTTPS redirection                         | `no`      |
| `AUTOCERT`              | Auto-generate self-signed SSL if none is found            | `no`      |
| `CERT_WARN_DAYS`        | Triggers a warning log if cert expires in < N days        | `30`      |

---

## 📁 Folder Structure (Mounted Volume)

```
config/
🔽️ www/                # Web content (index.php, etc.)
🔽️ ssl/                # SSL certs: fullchain.pem, privkey.pem
🔽️ data/               # Optional: databases, uploads
🔽️ warnings/           # Auto-generated logs (e.g., cert-warn.log)
```

---

## ❤️‍🩹 Healthcheck

Checks:

- Nginx process
- PHP-FPM process
- HTTP/HTTPS reachable (200, 403, 404)

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -s -L -o /dev/null -w "%{http_code}" http://localhost | grep -qE "200|403|404"
```

---

## 💪 Docker Usage

### Run directly

```bash
docker run -d --name my-nginx \
  -e TIMEZONE=America/New_York \
  -e PHP_MEMORY_LIMIT=512M \
  -e REDIRECT_TO_HTTPS=yes \
  -e AUTOCERT=yes \
  -p 8080:80 -p 8443:443 \
  -v $(pwd)/config:/config \
  humbertovarona/nginx
```

Access:

- `http://localhost:8080`
- `https://localhost:8443` (self-signed certificate)

---

## 🧼 docker-compose.yml

```yaml
version: '3'

services:
  web:
    image: humbertovarona/nginx
    container_name: my-nginx
    ports:
      - "8080:80"
      - "8443:443"
    environment:
      TIMEZONE: America/New_York
      PHP_MEMORY_LIMIT: 512M
      REDIRECT_TO_HTTPS: yes
      AUTOCERT: yes
      CERT_WARN_DAYS: 30
    volumes:
      - ./config:/config
    healthcheck:
      test: ["CMD-SHELL", "curl -s -L -o /dev/null -w '%{http_code}' http://localhost | grep -qE '200|403|404'"]
      interval: 30s
      timeout: 5s
      retries: 3
```

---

## 📜 License

MIT — Use it freely, fork it proudly.

---

## 🤝 Contributing

Pull requests, ideas, and bug reports are welcome 🙌

---

## 👨‍💼 Maintainer

**HL Varona** — [@humberto.varona@gmail.com](mailto:humberto.varona@gmail.com)
