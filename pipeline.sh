#!/bin/bash
set -e

WORK_DIR="/pipeline"
KEY_PATH="$WORK_DIR/testkey.pem"
PUBKEY_PATH="$WORK_DIR/testpub.pem"
ATTESTATION_PATH="$WORK_DIR/attestation.json"
SBOM_SPDX_PATH="$WORK_DIR/sbom-spdx.json"
SBOM_CDX_PATH="$WORK_DIR/sbom-cdx.json"
INTOTO_DIR="$WORK_DIR/in-toto"

echo "=== Step 1: Generate keypair ==="
openssl genpkey -algorithm ed25519 -outform PEM -out $KEY_PATH
openssl pkey -in $KEY_PATH -pubout > $PUBKEY_PATH
echo "Keypair generated"

echo "=== Step 2: Clone in-toto ==="
if [ ! -d "$INTOTO_DIR" ]; then
    git clone https://github.com/in-toto/in-toto.git $INTOTO_DIR
else
    echo "in-toto already exists, skipping clone"
fi

echo "=== Step 3: Run witness attestation (build step) ==="
witness run --step build -o $ATTESTATION_PATH -k $KEY_PATH -- pip3 install -e $INTOTO_DIR
echo "Attestation generated: $ATTESTATION_PATH"

echo "=== Step 4: Generate SBOM (SPDX 2.3) ==="
sbomit generate $ATTESTATION_PATH -o $SBOM_SPDX_PATH --format spdx23
echo "SBOM generated: $SBOM_SPDX_PATH"

echo "=== Step 5: Generate SBOM (CycloneDX 1.4) ==="
sbomit generate $ATTESTATION_PATH -o $SBOM_CDX_PATH --format cdx14
echo "SBOM generated: $SBOM_CDX_PATH"

echo "=== Pipeline complete ==="
ls -al $WORK_DIR