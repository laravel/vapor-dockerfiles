# Laravel Vapor Core / Runtime

[Laravel Vapor](https://vapor.laravel.com) is an auto-scaling, serverless deployment platform for Laravel, powered by AWS Lambda. Manage your Laravel infrastructure on Vapor and fall in love with the scalability and simplicity of serverless.

Vapor abstracts the complexity of managing Laravel applications on AWS Lambda, as well as interfacing those applications with SQS queues, databases, Redis clusters, networks, CloudFront CDN, and more.

This repository contains the base docker images used to make Laravel applications run smoothly in a docker & serverless environment. To learn more about Vapor and how to use this repository, please consult the [official documentation](https://docs.vapor.build).

## Building images

First, ensure you have [Docker](https://www.docker.com) installed in your machine, and access to the [`laravelphp`](https://hub.docker.com/u/laravelphp) Docker Hub organization.

Then, once docker is running in your machine, you may use the `build.sh` script to run build images:

```shell script
./build.sh php74
```

## Publishing images

If you wish to build, and publish the built image, you may use the `-p` option:

```shell script
./build.sh php74 -p
```
