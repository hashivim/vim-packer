#!/bin/bash
VERSION=$1

function usage {
    echo -e "
    USAGE EXAMPLES:

        ./$(basename $0) 0.8.7
        ./$(basename $0) 0.9.2
    "
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

EXISTING_PACKER_VERSION=$(packer version | head -n1 | awk '{print $2}' | sed 's/v//g')

if [ "${EXISTING_PACKER_VERSION}" != "${VERSION}" ]; then
    echo "-) You are trying to update this script for packer ${VERSION} while you have"
    echo "   packer ${EXISTING_PACKER_VERSION} installed at $(which packer)."
    echo "   Please update your local packer before using this script."
    exit 1
fi

echo "+) Acquiring packer-${VERSION}"
wget https://github.com/mitchellh/packer/archive/v${VERSION}.tar.gz

echo "+) Extracting packer-${VERSION}.tar.gz"
tar zxf v${VERSION}.tar.gz

echo "+) Running update_commands.rb"
./update_commands.rb

echo "+) Updating the badge in the README.md"
sed -i "/img.shields.io/c\[\![](https://img.shields.io/badge/Supports%20Packer%20Version-${VERSION}-blue.svg)](https://github.com/hashicorp/packer/blob/v${VERSION}/CHANGELOG.md)" README.md

echo "+) Cleaning up after ourselves"
rm -f v${VERSION}.tar.gz
rm -rf packer-${VERSION}

git status
