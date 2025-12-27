# -------- Builder Stage --------
FROM rust:1.92 AS builder

WORKDIR /app

# Install protoc (REQUIRED for tonic-build)
RUN apt-get update && \
    apt-get install -y protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*

# Copy manifests first (better caching)
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release || true

# Copy full source
COPY . .
RUN cargo build --release


# -------- Runtime Stage --------
FROM debian:bookworm-slim

WORKDIR /app

# Install runtime dependencies (OpenSSL 3 + certs)
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/payments_service .

EXPOSE 8001 50052

CMD ["./payments_service"]
