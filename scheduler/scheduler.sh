#!/bin/bash

if [ "$RACK_ENV" == "production" ]
then
  host='https://floofloo-api.herokuapp.com'
else
  host='http://host.docker.internal:9090'
fi

curl --request PUT "${host}/api/v1/scheduler"