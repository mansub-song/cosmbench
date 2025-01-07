#!/bin/bash

# create necessary structure if doesn't exist
if [[ ! -f /opt/data/priv_validator_state.json ]]
then
    mkdir /opt/data
    cat <<EOF > /opt/data/priv_validator_state.json
{
  "height": "0",
  "round": 0,
  "step": 0
}
EOF
fi

{
  sleep 2s
    
  VAL_ADDRESS=$(/usr/local/bin/gaiad keys show core1 --keyring-backend test --bech=val --home /opt -a)
  while true
  do
    /usr/local/bin/gaiad tx staking create-validator \
      /opt/config/validator.json \
      --chain-id="demo" \
      --from="core1" \
      --keyring-backend=test \
      --home=/opt \
      --broadcast-mode=sync \
      --fees="300000stake" \
      --yes
    output=$(/usr/local/bin/gaiad query staking validator "${VAL_ADDRESS}" 2>/dev/null)
    if [[ -n "${output}" ]] ; then
      break
    fi
    echo "trying to create validator..."
    sleep 1s
  done
} &

/usr/local/bin/gaiad start \
  --minimum-gas-prices 0stake \
  --home=/opt \
  --moniker="${MONIKER}" \
  --p2p.persistent_peers=4f17f0c82fcbf30f212601d084bad7f9624e3537@core0:26656 \
  --rpc.laddr=tcp://0.0.0.0:26657 \
