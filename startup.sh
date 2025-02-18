docker rm -f dev-setup
docker build -t setup-test .
docker run -it --name dev-setup setup-test /bin/bash
