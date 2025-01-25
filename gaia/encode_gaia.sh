#!/bin/sh

ACCOUNT_COUNT=2000
BINARY=gaiad
NODE_HOME=/opt
CHAIN_ID=local_devnet
SEND_AMOUNT=1stake

UNSIGNED_TX_PREFIX="unsigned_tx_"
SIGNED_TX_PREFIX="signed_tx_"
ENCODED_TX_PREFIX="encoded_tx_"
UNSIGNED_TX_ROOT_DIR="${CHAIN_ID}_unsigned_txs"
SIGNED_TX_ROOT_DIR="${CHAIN_ID}_signed_txs"
ENCODED_TX_ROOT_DIR="${CHAIN_ID}_encoded_txs"

mkdir -p "$UNSIGNED_TX_ROOT_DIR"
mkdir -p "$SIGNED_TX_ROOT_DIR"
mkdir -p "$ENCODED_TX_ROOT_DIR"

i=1500
while [ "$i" -lt "$ACCOUNT_COUNT" ]; do
    ACCOUNT_NAME="account_$i"
    ACCOUNT_ADDRESS=$($BINARY keys show "$ACCOUNT_NAME" -a --home "$NODE_HOME" --keyring-backend test)

    $BINARY tx bank send "$ACCOUNT_ADDRESS" "$ACCOUNT_ADDRESS" "$SEND_AMOUNT" --chain-id "$CHAIN_ID" --home "$NODE_HOME" --gas 800000 --fees 900000stake --keyring-backend test --generate-only > "$UNSIGNED_TX_ROOT_DIR/${UNSIGNED_TX_PREFIX}${i}"
    $BINARY tx sign "$UNSIGNED_TX_ROOT_DIR/${UNSIGNED_TX_PREFIX}${i}" --chain-id "$CHAIN_ID" --from "$ACCOUNT_NAME" --home "$NODE_HOME" --account-number "$i" --keyring-backend test > "$SIGNED_TX_ROOT_DIR/${SIGNED_TX_PREFIX}${i}" 2>&1
    ENCODED=$($BINARY tx encode "$SIGNED_TX_ROOT_DIR/${SIGNED_TX_PREFIX}${i}")
    echo "$ENCODED" > "$ENCODED_TX_ROOT_DIR/${ENCODED_TX_PREFIX}${i}"

    i=$((i + 1))
done

echo "123"