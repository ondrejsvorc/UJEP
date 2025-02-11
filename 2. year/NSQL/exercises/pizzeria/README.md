### Before dockerization

```
pip freeze > requirements.txt
```

```
py -m venv .venv
```

```
.venv\Scripts\activate
```

```
pip install -r requirements.txt
```

### Dockerization

```
pip freeze > requirements.txt
```

Dockerfile
```
FROM python:3.12-alpine
WORKDIR /code
COPY requirements.txt /code
RUN pip install -r requirements.txt --no-cache-dir
COPY ./code /code
CMD python app.py
```

docker-compose.yml
```
version: '3'
services:
  flask:
    build: .
    container_name: pizzeria-flask-container
    ports:
      - "5000:5000"
    volumes:
      - ./code:/code
    depends_on:
      - redis

  redis:
    image: redislabs/redismod
    container_name: pizzeria-redis-container
    ports:
      - "6379:6379"

  mongodb:
    image: mongo:latest
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin
    ports:
      - 27017:27017

  neo4j:
    image: neo4j:latest
    ports:
      - "7474:7474"
      - "7687:7687"
```

```
pip install redis
```

```
pip install SQLAlchemy
```

```
docker-compose build --no-cache
```

```
docker-compose up
```