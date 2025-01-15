#!/bin/bash

ACCOUNT_COUNT=2000
BINARY=axelard
NODE_HOME=/opt
CHAIN_ID=local-test
SEND_AMOUNT=1uaxl

UNSIGNED_TX_PREFIX="unsigned_tx_"
SIGNED_TX_PREFIX="signed_tx_"
ENCODED_TX_PREFIX="encoded_tx_"
UNSIGNED_TX_ROOT_DIR=$CHAIN_ID"_unsigned_txs"
SIGNED_TX_ROOT_DIR=$CHAIN_ID"_signed_txs"
ENCODED_TX_ROOT_DIR=$CHAIN_ID"_encoded_txs"

mkdir -p $UNSIGNED_TX_ROOT_DIR
mkdir -p $SIGNED_TX_ROOT_DIR
mkdir -p $ENCODED_TX_ROOT_DIR

for ((i=1500; i<ACCOUNT_COUNT; i++)); do
    ACCOUNT_NAME="account_$i"
    ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $NODE_HOME --keyring-backend test)

    $BINARY tx bank send $ACCOUNT_ADDRESS $ACCOUNT_ADDRESS $SEND_AMOUNT --home $NODE_HOME --chain-id $CHAIN_ID --gas 800000 --keyring-backend test --generate-only > $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$i
    $BINARY tx sign $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$i --from $ACCOUNT_NAME --chain-id $CHAIN_ID --home /opt --account-number $i --keyring-backend test > $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$i 2>&1
    ENCODED=`$BINARY tx encode $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$i`
    echo $ENCODED > $ENCODED_TX_ROOT_DIR/$ENCODED_TX_PREFIX$i
done

echo "123"