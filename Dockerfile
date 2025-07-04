FROM ubuntu:22.04

# Install system dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl build-essential pkg-config libssl-dev git protobuf-compiler wget unzip

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add RISC-V target
RUN rustup target add riscv32i-unknown-none-elf

# Download Nexus CLI directly
RUN mkdir -p /root/.nexus/bin
RUN curl -Lo /root/.nexus/bin/nexus https://github.com/nexus-xyz/nexus-cli/releases/latest/download/nexus-linux-amd64 
RUN chmod +x /root/.nexus/bin/nexus
ENV PATH="/root/.nexus/bin:${PATH}"

# Start the node
CMD ["sh", "-c", "nexus-network start --node-id 11874082 && tail -f /dev/null"]
