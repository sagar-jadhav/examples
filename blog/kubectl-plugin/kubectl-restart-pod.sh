#!/bin/bash

# Logging script execution start
echo "-------------------------"

DEPLOYMENT=$1
NAMESPACE=default

if [ ! -z $2 ]; then
    if [ $2 == "-n" ]; then
        NAMESPACE=$3
    fi
fi

# Logging name of the Deployment
echo "Deployment: $DEPLOYMENT"

# Logging name of the Namespace
echo "Namespace: $NAMESPACE"

# Retrieving Deployment
DEPLOYMENT_DETAILS={}

{
    DEPLOYMENT_DETAILS=$(kubectl get deploy $DEPLOYMENT -o json -n $NAMESPACE)
} || {
    echo "-------------------------"
    exit 1
}

# Retrieving the current replicas
CURRENT_REPLICAS=$(echo $DEPLOYMENT_DETAILS | jq .spec.replicas)

# Retrieving the labels
LABELS=$(echo $DEPLOYMENT_DETAILS | jq .spec.selector.matchLabels)
LABEL=$(echo $LABELS | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[0]')

# Scaling down the replicas
echo "Scaling down the replicas to 0"
kubectl scale --replicas=0 deploy/$DEPLOYMENT -n $NAMESPACE

while true; do

    PODS_COUNT=$(kubectl get po -l $LABEL -n $NAMESPACE -o json | jq '.items | length')

    if [ $PODS_COUNT == 0 ]; then
        break
    else
        printf "."
        sleep 5
    fi

done

# Scaling up the replicas
echo ""
echo "Scaling up replicas to $CURRENT_REPLICAS"
kubectl scale --replicas=$CURRENT_REPLICAS deploy/$DEPLOYMENT -n $NAMESPACE

while true; do

    INDEX=0
    RUNNING_COUNT=0
    PODS=$(kubectl get po -l $LABEL -n $NAMESPACE -o json | jq .items)

    while [ $INDEX -lt $CURRENT_REPLICAS ]; do
        PHASE=$(echo $PODS | jq -r --arg index $INDEX '.[$index | tonumber].status.phase')

        if [ $PHASE == "Running" ]; then
            RUNNING_COUNT=$((RUNNING_COUNT + 1))
        fi

        INDEX=$((INDEX + 1))
    done

    if [ $RUNNING_COUNT == $CURRENT_REPLICAS ]; then
        break
    else
        printf "."
        sleep 5
    fi

done

# Logging script execution end
echo ""
echo "-------------------------"
