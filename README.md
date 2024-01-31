# README

## SETUP ADN RUN
### 0. cd to root directory

### 1. Build image
```shell
docker build . --build-arg RUBY_VERSION=3.1.4 -t code-kata
```

### 2. Run container
```shell
docker run -it -v $(pwd):/app code-kata
```

### 3. Run test(in container)
After running tests, a coverage report will be generated in `coverage/index.html`.
```shell
rspec
```

### 3. Change permission(in container)
```shell
chmod +x bin/entry
```
