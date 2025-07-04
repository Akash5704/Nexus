FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl git build-essential libssl-dev protobuf-compiler

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add RISC-V target
RUN rustup target add riscv32i-unknown-none-elf

# Download and install Nexus CLI
RUN mkdir -p /root/.nexus/bin
RUN curl -sSL https://cli.nexus.xyz/  -o /tmp/install-nexus.sh && \
    chmod +x /tmp/install-nexus.sh && \
    NONINTERACTIVE=1 /tmp/install-nexus.sh

# Ensure nexus is in PATH
ENV PATH="/root/.nexus/bin:${PATH}"

# Keep container running
CMD ["sh", "-c", "nexus network start --node-id 11874082 && tail -f /dev/null"]
