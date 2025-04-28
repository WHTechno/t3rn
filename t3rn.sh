#!/bin/bash

# Menampilkan header
echo "===== T3RN V3 Node ====="
echo "======= WHTech ======="

# Membuat direktori t3rn dan masuk ke dalamnya
mkdir -p t3rn
cd t3rn

# Download versi terbaru dari Executor binary
echo "Downloading the latest Executor binary..."
curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
grep -Po '"tag_name": "\K.*?(?=")' | \
xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz

# Mengekstrak arsip
echo "Extracting the Executor binary..."
tar -xzf executor-linux-*.tar.gz

# Masuk ke direktori executor bin
cd executor/executor/bin

# Mengatur environment variable
echo "Setting environment variables..."
export ENVIRONMENT=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true

# Meminta pengguna untuk memasukkan private key
read -p "Enter your private key: " PRIVATE_KEY_LOCAL
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL

# Menentukan jaringan yang akan digunakan
export EXECUTOR_ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l2rn'

# Menentukan RPC URL untuk jaringan yang digunakan
export RPC_ENDPOINTS='{
    "l2rn": ["https://t3rn-b2n.blockpi.network/v1/rpc/public", "https://b2n.rpc.caldera.xyz/http"],
    "arbt": ["https://arbitrum-sepolia.drpc.org", "https://sepolia-rollup.arbitrum.io/rpc"],
    "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.drpc.org"],
    "blst": ["https://sepolia.blast.io", "https://blast-sepolia.drpc.org"],
    "mont": ["https://testnet-rpc.monad.xyz"],
    "opst": ["https://sepolia.optimism.io", "https://optimism-sepolia.drpc.org"],
    "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"]
}'

# Pengaturan batas gas
read -p "Enter the maximum gas price limit (in gwei, default 1000): " GAS_LIMIT
GAS_LIMIT=${GAS_LIMIT:-1000}  # Default to 1000 if no input is provided
export EXECUTOR_MAX_L3_GAS_PRICE=$GAS_LIMIT
echo "Gas price limit set to $EXECUTOR_MAX_L3_GAS_PRICE gwei."

# Menjalankan Executor
echo "Running the Executor..."
./executor
