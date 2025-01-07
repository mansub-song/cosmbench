import nacl.signing
import base64
import json

# Generate Ed25519 Key Pair
key_pair = nacl.signing.SigningKey.generate()
public_key = key_pair.verify_key

# Encode to Base64
private_key_base64 = base64.b64encode(key_pair._seed).decode('utf-8')
public_key_base64 = base64.b64encode(bytes(public_key)).decode('utf-8')

# Create Address
address = public_key.to_curve25519_public_key().encode().hex().upper()[:40]

# Construct JSON
key_pair_json = {
    "address": address,
    "pub_key": {
        "type": "tendermint/PubKeyEd25519",
        "value": public_key_base64
    },
    "priv_key": {
        "type": "tendermint/PrivKeyEd25519",
        "value": private_key_base64
    }
}

# Print JSON
print(json.dumps(key_pair_json, indent=2))
