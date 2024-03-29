networks:
  default:
    external:
      name: roboshop
services:
  # docker run -d --name mongodb --network=roboshop mongodb:1
  mongodb:
    image: mongodb:1
    container_name: mongodb
    # networks:
    # - roboshop

  catalogue:
    image: catalogue:1
    container_name: catalogue
    # networks:
    # - roboshop
    depends_on:
    - mongodb

  web:
    image: web:1
    container_name: web
    ports:
    - "80:80"
    depends_on:
    - catalogue
    - cart
    - user
    - shipping
    - payment

  redis:
    image: redis
    container_name: redis

  user:
    image: user:1
    container_name: user
    depends_on:
    - redis
    - mongodb

  cart:
    image: cart:1
    container_name: cart
    depends_on:
    - redis
    - catalogue

  mysql:
    image: mysql:1
    container_name: mysql

  shipping:
    image: shipping:1
    container_name: shipping
    depends_on:
    - mysql

  rabbitmq:
    container_name: rabbitmq
    image: rabbitmq
    environment:
    - RABBITMQ_DEFAULT_USER=roboshop
    - RABBITMQ_DEFAULT_PASS=roboshop123

  payment:
    container_name: payment
    image: payment:1
    depends_on:
    - rabbitmq
    - user
    - cart
