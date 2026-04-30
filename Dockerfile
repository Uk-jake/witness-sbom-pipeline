FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    openssl \
    jq \
    curl \
    git \
    wget \
    ca-certificates \
    nano \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Go 1.22.2
RUN wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz && \
    rm go1.22.2.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/root/go
ENV PATH=$PATH:/root/go/bin

# Install Witness v0.5.2
RUN curl -LO https://github.com/testifysec/witness/releases/download/v0.5.2/witness_0.5.2_linux_amd64.tar.gz && \
    tar -xf witness_0.5.2_linux_amd64.tar.gz && \
    mv witness /usr/local/bin/ && \
    rm witness_0.5.2_linux_amd64.tar.gz

# Install SBOMit (build from source to avoid CGO issues on ARM64)
RUN git clone https://github.com/SBOMit/sbomit.git /opt/sbomit && \
    cd /opt/sbomit && \
    CGO_ENABLED=0 go build -o /usr/local/bin/sbomit .

WORKDIR /pipeline

# Initialize git repository for witness git attestor
RUN git init && \
    git config --global user.email "pipeline@witness" && \
    git config --global user.name "witness-pipeline"

CMD ["/bin/bash"]