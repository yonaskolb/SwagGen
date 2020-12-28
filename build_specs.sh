#!/bin/bash
set -e

swift build
for spec in Specs/**
do
    echo ""
    sh build_spec.sh ${spec}
done
