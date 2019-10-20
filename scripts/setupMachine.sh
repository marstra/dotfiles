#!/bin/bash
set -e
BASE_DIR=$(dirname $(readlink -f $0))
$BASE_DIR/installTools.sh
$BASE_DIR/installFonts.sh
$BASE_DIR/setupLinks.sh
