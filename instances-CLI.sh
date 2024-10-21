#!/bin/bash

instance_name=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
domain_name="devops-srinu.online"
hosted_zone_id="Z06678691JW1MIBEWXR03"

for name in ${instance_name[@]}; do
    if [ $name == "shipping" ] || [ $name == "mysql" ]
then
    instance_type="t3.medium"
else
    instance_type="t3.micro"
fi
    echo "creatiing insatnces $name:$instance_type"
    insatnce_id=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type $instance_type --security-group-ids sg-0ecfbd8f3efc72ed0 --subnet-id subnet-0bf7e058ff1f78d08  --query 'Instances[0].InstanceId' --output text)
    echo "Instance created for: $instance_name"

    aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$instance_name

    if [ $instance_name == "web" ]
    then
        aws ec2 wait instance-running --instance-ids $instance_id
        public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].[PublicIpAddress]' --output text)
        ip_to_use=$public_ip
    else
        private_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].[PrivateIpAddress]' --output text)
        ip_to_use=$private_ip
    fi

    echo "creating R53 record for $instance_name"
    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch '
    {
        "Comment": "Creating a record set for '$instance_name'"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$name.$domain_name'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$ip_to_use'"
            }]
        }
        }]
    }'
    
done