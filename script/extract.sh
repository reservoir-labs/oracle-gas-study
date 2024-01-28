#!/bin/bash

set -euxo pipefail

function extract_gas () {
    cat \
    | grep "ONCHAIN EXECUTION COMPLETE & SUCCESSFUL." -B 11 \
    | head --lines=1 \
    | awk -F '[ (]' '{print $5}'
}

./script/gas/run_benchmark.sh "swap1-token2" \
    | extract_gas \
    > .benchmarks/swap1-token2.gas

