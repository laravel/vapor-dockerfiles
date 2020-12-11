To build and publish an image;

```shell script
docker build -f ${PWD}/php74.Dockerfile -t vapor-php74:latest .

docker tag vapor-php74:latest laravelphp/vapor:php74

docker push laravelphp/vapor:php74
```