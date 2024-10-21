#!/bin/bash

instance_name=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")

for name in ${instance_name[@]}; do
    if [ $name == "shipping" ] || [ $name == "mysql" ]
then
    instance_type="t3.medium"
else
    instance_type="t3.micro"
fi
    echo "creatiing insatnces $name:$instance_type"
done