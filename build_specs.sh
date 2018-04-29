#!/bin/bash

for spec in Specs/**
do
    echo ""
    sh build_spec.sh ${spec}
done
