#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

go run ../ -t
go run ../ double-width
go run ../ decimal -t
go run ../ signed-decimal -t
