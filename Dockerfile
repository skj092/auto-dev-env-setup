FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y sudo git

RUN useradd -m testuser && echo "testuser:testuser" | chpasswd && usermod -aG sudo testuser

RUN echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER testuser

WORKDIR /home/testuser

COPY setup_script.sh .

RUN sudo chmod +x setup_script.sh

CMD ["/bin/bash"]
