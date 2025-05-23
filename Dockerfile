# Stage 1: Builder
FROM python:3.8 AS builder
WORKDIR /app

COPY requirements.txt ./
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    gcc \
    python3-dev \
    build-essential \
 && pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.8 AS run
WORKDIR /app
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y netcat-openbsd

COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY . .

RUN chmod +x /app/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
