#!/bin/bash
source ./env.sh

# First, create accounts and add them to genesis
for ((i=0;i<$NODE_COUNT;i++))
do            
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$i


    cp -f $CURRENT_DATA_DIR/config/sample_genesis.json $CURRENT_DATA_DIR/config/genesis.json

    echo "$BINARY keys add $ACCOUNT_NAME --keyring-backend $KEYRING_BACKEND --home $CURRENT_DATA_DIR"
    $BINARY keys add $ACCOUNT_NAME --keyring-backend $KEYRING_BACKEND --home $CURRENT_DATA_DIR

    ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $CURRENT_DATA_DIR --keyring-backend $KEYRING_BACKEND)



    echo "$BINARY genesis add-genesis-account $ACCOUNT_ADDRESS $UNIT --home $CURRENT_DATA_DIR --chain-id $CHAIN_ID"


    $BINARY genesis add-genesis-account $ACCOUNT_ADDRESS 9990004452404000000000$UNIT --home $CURRENT_DATA_DIR --chain-id $CHAIN_ID

    if [ $CURRENT_DATA_DIR = $GENESIS_DIR  ]; then
        continue
    fi
    
    $BINARY genesis add-genesis-account $ACCOUNT_ADDRESS 9990004452404000000000$UNIT --home $GENESIS_DIR --chain-id $CHAIN_ID

   
    # echo $NUMBER
done
    
# Then create gentx for each validator
for ((i=0;i<$NODE_COUNT;i++))
do          
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$i
    

    $BINARY genesis gentx $ACCOUNT_NAME 9910004452404000000000$UNIT --chain-id $CHAIN_ID --keyring-backend $KEYRING_BACKEND --home $CURRENT_DATA_DIR
    

    cp -f "$CURRENT_DATA_DIR/config/gentx/"* "$GENESIS_DIR/config/gentx/"
    $BINARY genesis collect-gentxs --home $GENESIS_DIR

    
    rm -rf $CURRENT_DATA_DIR/keyring-test
done

cp -f $GENESIS_DIR/config/genesis.json $GENESIS_DIR/config/validator_genesis.json


echo "## Assign validator done and insert into genesis.json of node0 ##"


echo "### 2_assign_validator.sh done"