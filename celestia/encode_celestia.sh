#!/bin/bash

NODE_COUNT=4
ACCOUNT_COUNT_PER_LOOP=500
BINARY=/Users/kyungmin/go/bin/celestia-appd
MONIKER=core
CHAIN_ID=local_devnet
NODE_ROOT_DIR=/Users/kyungmin/go/bin
KEYRING_BACKEND="test"
ACCOUNT_DIR=/Users/kyungmin/go/bin/accounts
ACCOUNT_NAME_PREFIX="account_"
GENESIS_DIR=$NODE_ROOT_DIR"/node0"
SEND_AMOUNT=100
UNIT="stake"
UNSIGNED_TX_PREFIX="unsigned_tx_"
SIGNED_TX_PREFIX="signed_tx_"
ENCODED_TX_PREFIX="encoded_tx_"

UNSIGNED_TX_ROOT_DIR=$CHAIN_ID"_unsigned_txs"
SIGNED_TX_ROOT_DIR=$CHAIN_ID"_signed_txs"
ENCODED_TX_ROOT_DIR=$CHAIN_ID"_encoded_txs"


rm -rf $UNSIGNED_TX_ROOT_DIR
rm -rf $SIGNED_TX_ROOT_DIR
rm -rf $ENCODED_TX_ROOT_DIR

mkdir -p $UNSIGNED_TX_ROOT_DIR
mkdir -p $SIGNED_TX_ROOT_DIR
mkdir -p $ENCODED_TX_ROOT_DIR




echo "Done"