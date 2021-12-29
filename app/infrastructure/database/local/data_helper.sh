#!/bin/bash

host='http://127.0.0.1:9090'
issues=('disease' 'rights' 'disaster' 'hunger' 'water' 'climate') 

declare -A events
events=(
  ['disease']='covid,chronic,infection,diabetes,tuberculosis',
  ['rights']='democracy,violence,inequality,corruption',
  ['disaster']='earthquake,flood,storm,wildfire,tornado,famine,war',
  ['hunger']='hunger,food,poverty,starvation',
  ['water']='drought,flood,pollution,sea,river,sanitation',
  ['climate']='warming,cold,heat,frost,snow,ocean,forest,pollution'
)

IFS=','
for issue in "${issues[@]}"
do
    curl --request POST "${host}/api/v1/issue/${issue}"

    read -ra event_array <<< "${events[$issue]}"
    for event in "${event_array[@]}"
    do
        curl --request POST "${host}/api/v1/issue/${issue}/event/${event}"
    done
done
