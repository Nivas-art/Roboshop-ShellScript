#!/bin/bash

instance_name=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")

for name in ${instance_name[@]}; do
    echo "creatiing insatnces $name"
done