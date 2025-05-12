#!/bin/bash

# Menampilkan header
show_logo() {
echo -e "\e[34m░██╗░░░░░░░██╗██╗░░██╗████████╗███████╗░█████╗░██╗░░██╗\e[0m\n\
\e[34m░██║░░██╗░░██║██║░░██║╚══██╔══╝██╔════╝██╔══██╗██║░░██║\e[0m\n\
\e[34m░╚██╗████╗██╔╝███████║░░░██║░░░█████╗░░██║░░╚═╝███████║\e[0m\n\
\e[37m░░████╔═████║░██╔══██║░░░██║░░░██╔══╝░░██║░░██╗██╔══██║\e[0m\n\
\e[37m░░╚██╔╝░╚██╔╝░██║░░██║░░░██║░░░███████╗╚█████╔╝██║░░██║\e[0m\n\
\e[37m░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝░░░╚═╝░░░╚══════╝░╚════╝░╚═╝░░╚═╝\e[0m"
}

# Update dan bersihkan sistem
echo "Updating system..."
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Hapus direktori lama dan buat ulang
cd $HOME
rm -rf t3rn
mkdir t3rn && cd t3rn

# Download dan ekstrak executor terbaru
echo "Downloading the latest Executor binary..."
curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
grep -Po '"tag_name": "\K.*?(?=")' | \
xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz

echo "Extracting the Executor binary..."
tar -xzf executor-linux-*.tar.gz
cd executor/executor/bin

# Mengatur environment variable
echo "Setting environment variables..."
export ENVIRONMENT=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_BIDS_ENABLED=false
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
export EXECUTOR_MAX_L3_GAS_PRICE=150
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true

# Meminta input private key dari user
read -p "Enter your EVM private key: " PRIVATE_KEY_INPUT
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_INPUT

# Menentukan jaringan dan aset yang digunakan
export EXECUTOR_ENABLED_NETWORKS='l2rn,arbitrum-sepolia,base-sepolia,binance-testnet,blast-sepolia,monad-testnet,optimism-sepolia,sei-testnet,unichain-sepolia'
export EXECUTOR_ENABLED_ASSETS="eth,t3eth,t3mon,t3sei,mon,sei,bnb"

# Menentukan RPC endpoints
export RPC_ENDPOINTS='{
    "l2rn": ["https://t3rn-b2n.blockpi.network/v1/rpc/public", "https://b2n.rpc.caldera.xyz/http"],
    "arbt": ["https://arbitrum-sepolia.drpc.org", "https://sepolia-rollup.arbitrum.io/rpc"],
    "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.drpc.org"],
    "bsct": ["https://bsc-testnet.public.blastapi.io", "https://bsc-testnet.drpc.org", "https://bsc-testnet-rpc.publicnode.com"],
    "blst": ["https://sepolia.blast.io", "https://blast-sepolia.drpc.org"],
    "mont": ["https://testnet-rpc.monad.xyz", "https://monad-testnet.drpc.org"],
    "opst": ["https://sepolia.optimism.io", "https://optimism-sepolia.drpc.org"],
    "seit": ["https://sei-testnet.drpc.org", "https://evm-rpc-testnet.sei-apis.com"],
    "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"]
}'

# Menjalankan executor
echo "Running the Executor..."
./executor
