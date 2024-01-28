#!/bin/bash
set -euxo pipefail

# Constants
TEST_PRIVATE_KEY=0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf4356

# Anvil cannot already be running or this will cause issues.
nohup anvil -f "https://api.avax.network/ext/bc/C/rpc" &>/dev/null &
anvil_pid=$!

# Kill anvil on exit.
function cleanup {
  test -z $anvil_pid || kill $anvil_pid
}
trap cleanup EXIT

# Anvil needs some time to bind the port.
sleep 10

forge script script/gas/Benchmarks.s.sol \
    --sig "run()" \
    --non-interactive \
    --broadcast \
    --target-contract Benchmarks \
    --rpc-url http://127.0.0.1:8545 \
    --sender 0x14dc79964da2c08b23698b3d3cc7ca32193d9955 \
    --private-keys $TEST_PRIVATE_KEY \
    --private-keys 0x000000000000000000000000000000000000000000000000000000000000a1ce \
    --private-keys 0x0000000000000000000000000000000000000000000000000000000000000b0b \
    --private-keys 0x0000000000000000000000000000000000000000000000000000000000000ca1 \
    -vvvv

