#!/bin/bash

ACCOUNT_COUNT=500
BINARY=cronosd
NODE_HOME=/opt
CHAIN_ID=localtestnet_338-1
SEND_AMOUNT=1ucro

UNSIGNED_TX_PREFIX="unsigned_tx_"
SIGNED_TX_PREFIX="signed_tx_"
ENCODED_TX_PREFIX="encoded_tx_"
UNSIGNED_TX_ROOT_DIR=$CHAIN_ID"_unsigned_txs"
SIGNED_TX_ROOT_DIR=$CHAIN_ID"_signed_txs"
ENCODED_TX_ROOT_DIR=$CHAIN_ID"_encoded_txs"

mkdir -p $UNSIGNED_TX_ROOT_DIR
mkdir -p $SIGNED_TX_ROOT_DIR
mkdir -p $ENCODED_TX_ROOT_DIR

for ((i=0; i<ACCOUNT_COUNT; i++)); do
    ACCOUNT_NAME="account_$i"
    ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $NODE_HOME --keyring-backend test)

    $BINARY tx bank send $ACCOUNT_ADDRESS $ACCOUNT_ADDRESS $SEND_AMOUNT --home $NODE_HOME --chain-id $CHAIN_ID --gas 800000 --gas-prices 7ucro --fees 600000000ucro --keyring-backend test --generate-only > $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$i
    $BINARY tx sign $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$i --from $ACCOUNT_NAME --chain-id $CHAIN_ID --home /opt --account-number $i --keyring-backend test > $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$i 2>&1
    ENCODED=`$BINARY tx encode $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$i`
    echo $ENCODED > $ENCODED_TX_ROOT_DIR/$ENCODED_TX_PREFIX$i
done


# cronosd keys show account_0 -a --home /opt --keyring-backend test
# cronosd tx bank send crc1j2g6gdcv05ts4yu7rh0vhvu0sqgn2up7luuwnz crc1j2g6gdcv05ts4yu7rh0vhvu0sqgn2up7luuwnz 1ucro --home /opt --chain-id localtestnet_338-1 --gas 800000 --gas-prices 7ucro --keyring-backend test --yes


cronosd tx bank send crc1fp5xsec06dwxajetftz342yavy8jkv6794zupv crc1fp5xsec06dwxajetftz342yavy8jkv6794zupv 1basetcro --home /opt --chain-id localtestnet_338-1 --gas 800000 --fees 7basetcro --keyring-backend test --yes


cronosd tx bank send crc1fp5xsec06dwxajetftz342yavy8jkv6794zupv crc1fp5xsec06dwxajetftz342yavy8jkv6794zupv 1basetcro --keyring-backend test --chain-id localtestnet_338-1 --home /opt