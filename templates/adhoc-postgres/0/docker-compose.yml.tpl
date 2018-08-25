version: '2'
services:
  postgres:
    image: postgres:${POSTGRES_TAG}
    environment:
      PGDATA: /var/lib/postgresql/data/pgdata
      POSTGRES_DB: ${postgres_db}
      POSTGRES_USER: ${postgres_user}
      POSTGRES_PASSWORD: ${postgres_password}
    tty: true
    stdin_open: true
    command:
      - -c max_connections=${max_connections}
      - -c shared_buffers=${shared_buffers}
      - -c work_mem=${work_mem}
      - -c effective_cache_size=${effective_cache_size}
      {{- if ne .Values.server_configuration "" }}
      - ${server_configuration}
      {{- end}}
    labels:
      io.rancher.scheduler.affinity:host_label: ${host_label}
    volumes:
      - pgdata:/var/lib/postgresql/data/pgdata
volumes:
  pgdata:
    driver: local
    per_container: true
