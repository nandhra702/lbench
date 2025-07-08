#!/bin/bash
set -e

# Step 1: Install system packages
apt update && apt install -y \
  build-essential \
  gcc g++ \
  python3 python3-pip \
  ghc cabal-install \
  ocaml ocaml-findlib \
  curl wget git unzip pkg-config libssl-dev \
  software-properties-common

# Step 2: Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"

# Step 3: Install Go from official source
GO_VERSION=1.22.2
cd /tmp
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# Step 4: Persist environment variables to .bashrc
cat <<'EOF' >> ~/.bashrc

# Language toolchain paths
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
EOF

# Step 5: Apply immediately
source ~/.bashrc

# Step 6: Install Zig
ZIG_VERSION=0.12.0
cd /opt
wget https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz
tar -xf zig-linux-x86_64-${ZIG_VERSION}.tar.xz
rm zig-linux-x86_64-${ZIG_VERSION}.tar.xz
ln -s /opt/zig-linux-x86_64-${ZIG_VERSION} /opt/zig

# Add to PATH
echo 'export PATH="/opt/zig:$PATH"' >> ~/.bashrc
export PATH="/opt/zig:$PATH"
