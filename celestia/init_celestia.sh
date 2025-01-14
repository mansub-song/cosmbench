#!/bin/bash

NODE_COUNT=4
ACCOUNT_COUNT_PER_LOOP=500
BINARY=/Users/kyungmin/go/bin/injectived
MONIKER=core
CHAIN_ID=local_devnet
NODE_ROOT_DIR=/Users/kyungmin/go/bin
KEYRING_BACKEND="test"
ACCOUNT_DIR=/Users/kyungmin/go/bin/accounts
ACCOUNT_NAME_PREFIX="account_"
GENESIS_DIR=$NODE_ROOT_DIR"/node0"
UNIT="stake"
SEND_AMOUNT=100

UNSIGNED_TX_PREFIX="unsigned_tx_"
SIGNED_TX_PREFIX="signed_tx_"
ENCODED_TX_PREFIX="encoded_tx_"
UNSIGNED_TX_ROOT_DIR=$CHAIN_ID"_unsigned_txs"
SIGNED_TX_ROOT_DIR=$CHAIN_ID"_signed_txs"
ENCODED_TX_ROOT_DIR=$CHAIN_ID"_encoded_txs"

for ((i=0;i<$NODE_COUNT;i++))
do

    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    $BINARY init $MONIKER$i --chain-id $CHAIN_ID --home $CURRENT_DATA_DIR
    cp -f $CURRENT_DATA_DIR/config/genesis.json $CURRENT_DATA_DIR/config/sample_genesis.json

done

for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    $BINARY tendermint show-node-id --home $CURRENT_DATA_DIR
done

echo "Finish 1"

for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$i
    cp -f $CURRENT_DATA_DIR/config/sample_genesis.json $CURRENT_DATA_DIR/config/genesis.json

    $BINARY keys add $ACCOUNT_NAME --keyring-backend $KEYRING_BACKEND --home $CURRENT_DATA_DIR
    ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $CURRENT_DATA_DIR --keyring-backend $KEYRING_BACKEND)


    $BINARY genesis add-genesis-account $ACCOUNT_ADDRESS 9990004452404000000000$UNIT --home $CURRENT_DATA_DIR --chain-id $CHAIN_ID
    if [ $CURRENT_DATA_DIR = $GENESIS_DIR  ]; then
        continue
    fi
    $BINARY genesis add-genesis-account $ACCOUNT_ADDRESS 9990004452404000000000$UNIT --home $GENESIS_DIR --chain-id $CHAIN_ID
done

for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$i

    $BINARY genesis gentx $ACCOUNT_NAME 9910004452404000000000$UNIT --keyring-backend $KEYRING_BACKEND --chain-id $CHAIN_ID --home $CURRENT_DATA_DIR

    cp -f "$CURRENT_DATA_DIR/config/gentx/"* "$GENESIS_DIR/config/gentx/"
    $BINARY genesis collect-gentxs --home $GENESIS_DIR

    rm -rf $CURRENT_DATA_DIR/keyring-test
done

echo "Finish 2"

for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i

    for ((j=0;j<$ACCOUNT_COUNT_PER_LOOP;j++))
    do
        NUMBER=$(($((i*$ACCOUNT_COUNT_PER_LOOP))+j))
        ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$NUMBER

        $BINARY keys add $ACCOUNT_NAME --keyring-backend $KEYRING_BACKEND --home $CURRENT_DATA_DIR
        ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $CURRENT_DATA_DIR --keyring-backend $KEYRING_BACKEND)
        $BINARY genesis add-genesis-account $ACCOUNT_ADDRESS 10000000000000$UNIT --home $GENESIS_DIR --chain-id $CHAIN_ID
    done
done

rm -rf $ACCOUNT_DIR
mkdir $ACCOUNT_DIR
for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i

    mkdir -p $ACCOUNT_DIR/node$i
    cp -f $CURRENT_DATA_DIR/keyring-test/*.info $ACCOUNT_DIR/node$i
done


for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i

    for ((j=0;j<$ACCOUNT_COUNT_PER_LOOP;j++))
    do
        NUMBER=$(($((i*$ACCOUNT_COUNT_PER_LOOP))+j))
        ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$NUMBER
        ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $CURRENT_DATA_DIR --keyring-backend $KEYRING_BACKEND)
    done
done

echo "Finish 3"


for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    for ((j=0;j<$ACCOUNT_COUNT_PER_LOOP;j++))
    do
        NUMBER=$(($((i*$ACCOUNT_COUNT_PER_LOOP))+j))
        ACCOUNT_NUMBER=$(($NUMBER+4))
        ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$NUMBER
        ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $CURRENT_DATA_DIR --keyring-backend test)
        $BINARY tx bank send $ACCOUNT_ADDRESS $ACCOUNT_ADDRESS $SEND_AMOUNT$UNIT --chain-id $CHAIN_ID --home $CURRENT_DATA_DIR --keyring-backend test --generate-only > $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$NUMBER
        $BINARY tx sign $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$NUMBER --chain-id $CHAIN_ID --from $ACCOUNT_NAME --home $CURRENT_DATA_DIR --offline --sequence 0 --account-number $ACCOUNT_NUMBER --keyring-backend test > $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$NUMBER 2>&1
        ENCODED=`$BINARY tx encode $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$NUMBER`
        echo $ENCODED > $ENCODED_TX_ROOT_DIR/$ENCODED_TX_PREFIX$NUMBER
    done
done

echo "Finish 4"