#!/bin/bash

# Retrieve file
wget "https://docs.google.com/spreadsheets/d/15J_R5yu_9qDWeey7fRx4YH6wiRxlhW8BvFOvXpU_8qc/export?format=csv&gid=476018746" -O "content.csv"

# Arquivo CSV
csv_file="content.csv"

# Reseta workspace cadastrado para integração com a Inde
#curl -v -u admin:001q2w3e4r5t6y00 -XDELETE http://172.18.17.30:8080/geoserver/rest/workspaces/zcm/datastores/zcm_ds/featuretypes


# Itera sobre cada linha do CSV
while IFS=',' read -r col1 col2 col3 col4 col5 layer_name layer_title font_name col_8 col_9
do
    layer_name=$(echo "$layer_name" | tr '[:upper:]' '[:lower:]')
    curl -v -u admin:001q2w3e4r5t6y00 -XPOST -H "Content-type: text/xml" -d "<featureType><name>$layer_name</name><title>$layer_title</title></featureType>" http://172.18.17.30:8080/geoserver/rest/workspaces/zcm/datastores/zcm_ds/featuretypes
	curl -v -u admin:001q2w3e4r5t6y00 -XPUT -H "Content-type: text/xml" -d "<layer><defaultStyle><name>${layer_name}_style</name><workspace>zcm</workspace></defaultStyle></layer>" http://172.18.17.30:8080/geoserver/rest/layers/zcm:${layer_name}
done < "$csv_file"
