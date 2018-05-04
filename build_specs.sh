#!/bin/bash

swift build
for spec in Specs/**
do
    sh build_spec.sh ${spec}
done
