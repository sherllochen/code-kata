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

### 4. Change permission(in container)
```shell
chmod +x bin/entry
```

### 5. Run cli application(in container). The environment variables are all optional.
- MOCK: default as false, when given, there will be no real request.
- AMOUNT: default as 20, the amount of urls.
- THREAD: default as 2, the amount of request threads running in parallel.
```shell
MOCK=1 AMOUNT=100 THREAD=2 bin/entry
```