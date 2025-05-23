# Stage 1: Builder
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} AS builder

WORKDIR /app
COPY requirements.txt .

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    gcc \
    python3-dev \
    build-essential \
    netcat-openbsd

RUN pip install --upgrade pip

# Stage 2: Run
FROM python:${PYTHON_VERSION} AS run

WORKDIR /app
ENV PYTHONUNBUFFERED=1

COPY --from=builder /app /app
COPY . /app

RUN apt-get update && apt-get install -y netcat-openbsd \
 && pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]

