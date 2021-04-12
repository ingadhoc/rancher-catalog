version: '2'
services:
  postgres:
    image: postgres:${POSTGRES_TAG}
    environment:
      PGDATA: /var/lib/postgresql/data/pgdata
      POSTGRES_DB: ${postgres_db}
      POSTGRES_USER: ${postgres_user}
      POSTGRES_PASSWORD: ${postgres_password}
      PGDATABASE: ${postgres_db}
      PGUSER: ${postgres_user}
      PGPASSWORD: ${postgres_password}
      PGPORT: ${server_port}
    tty: true
    network_mode: host
    stdin_open: true
    oom_kill_disable: true
    shm_size: ${shm_size}
    command: docker-entrypoint.sh postgres -p ${server_port} -c max_connections=${max_connections} -c shared_buffers=${shared_buffers} -c work_mem=${work_mem} -c effective_cache_size=${effective_cache_size} ${server_configuration}
    labels:
      io.rancher.scheduler.affinity:host_label: ${host_label}
    volumes:
      - ${volumen_name}:/var/lib/postgresql/data/pgdata

  pg-idle-killer:
    image: postgres:${POSTGRES_TAG}
    environment:
      PGDATABASE: ${postgres_db}
      PGUSER: ${postgres_user}
      PGPASSWORD: ${postgres_password}
      PGPORT: ${server_port}
      PGHOST: pg
    stdin_open: true
    entrypoint:
    - psql
    - -c
    - SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND state = 'idle' AND state_change < current_timestamp - INTERVAL '${pgkiller_idle_max_interval}' MINUTE;
    tty: true
    links:
    - postgres:pg
    labels:
      cron.schedule: ${pgkiller_cron_schedule}
      cron.restart_timeout: '60'
      cron.action: restart
      io.rancher.scheduler.affinity:host_label: ${host_label}
      io.rancher.container.start_once: 'true'

{{- if eq .Values.pgdata_path "false" }}
volumes:
  ${volumen_name}:
    driver: local
    external: true
{{- end}}
