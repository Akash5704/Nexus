FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl git build-essential pkg-config libssl-dev protobuf-compiler wget unzip

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add RISC-V target
RUN rustup target add riscv32i-unknown-none-elf

# Clone and build nexus-cli from source
RUN mkdir -p /root/nexus && cd /root/nexus && \
    git clone https://github.com/nexus-xyz/nexus-cli.git  . && \
    cargo build --release

# Symlink binary into PATH
RUN ln -s /root/nexus/target/release/nexus-cli /usr/local/bin/nexus

# Start node
CMD ["sh", "-c", "nexus network start --node-id your-node-id && tail -f /dev/null"]
