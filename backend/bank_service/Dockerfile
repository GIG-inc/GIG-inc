# =========================
# Stage 1: Build Rust binary
# =========================
FROM rust:latest AS builder

# Install system dependencies for building Rust and Protobufs
RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    cmake \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# In the builder stage
WORKDIR /app

# Copy Rust source
COPY ./bank_service ./bank_service

# Copy proto files
COPY ./proto ./proto

WORKDIR /app/bank_service

# Build
RUN cargo build --release

# =========================
# Stage 2: Create minimal runtime image
# =========================
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from builder stage
COPY --from=builder /app/bank_service/target/release/bank_service /usr/local/bin/bank_service

# Set working directory
WORKDIR /app

# Expose gRPC port
EXPOSE 8000

# Run the service
CMD ["bank_service"]
