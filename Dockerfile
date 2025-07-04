FROM ubuntu:22.04

# Install system dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl build-essential pkg-config libssl-dev git protobuf-compiler

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add RISC-V target
RUN rustup target add riscv32i-unknown-none-elf

# Download and install Nexus CLI
RUN curl https://cli.nexus.xyz/  | sh
ENV PATH="/root/.nexus/bin:${PATH}"

# Set working directory
WORKDIR /root/nexus-node

# Start the node
CMD ["nexus-network", "start", "--node-id", "11874082"]