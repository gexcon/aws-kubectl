FROM python:latest

# install latest kubectl # TODO: arg to select release version? # TODO: arch support?
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# step down from root
RUN adduser user
USER user
WORKDIR /home/user
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/user/.local/bin

# install awscli
RUN python -m pip install awscliv2 --user && awsv2 --install

# convenience symlink for aws --> awsv2
RUN ln -sr /home/user/.local/bin/awsv2 /home/user/.local/bin/aws

# TODO: do we want a different command or entrypoint?
CMD [ "/bin/bash" ]
