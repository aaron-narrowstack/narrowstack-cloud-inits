mkdir -p /opt/app/n8n
touch /opt/app/n8n/docker-compose.yml
cat > /opt/app/n8n/docker-compose.yml << N8N
version: '3.8'
services:
  n8n:
    image: n8nio/n8n
    container_name: n8n
    environment:
      - N8N_HOST=${N8N_HOST}
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=${WEBHOOK_URL}
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=change-this-strong-password
    volumes:
      - /opt/app/n8n/n8n_data:/home/node/.n8n
    labels:
      - traefik.enable=true
      - "traefik.http.routers.n8n.rule=Host(\`${N8N_HOST}\`)"
      - traefik.http.routers.n8n.entrypoints=websecure
      - traefik.http.routers.n8n.tls.certresolver=letsencrypt
      - traefik.http.services.n8n.loadbalancer.server.port=5678
    restart: unless-stopped
    networks:
      - app-network
networks:
  app-network:
    external: true
N8N
mkdir -p /opt/app/n8n/n8n_data
chown -R 1000:1000 /opt/app/n8n/n8n_data
docker compose -f /opt/app/n8n/docker-compose.yml up -d
