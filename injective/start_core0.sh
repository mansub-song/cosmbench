#!/bin/bash

if [ ! -f /opt/data/priv_validator_state.json ]
then
    mkdir -p /opt/data
    cat <<EOF > /opt/data/priv_validator_state.json
{
  "height": "0",
  "round": 0,
  "step": 0
}
EOF
fi

/usr/local/bin/injectived start \
  --minimum-gas-prices 0stake \
  --home /opt \
  