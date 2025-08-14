#!/bin/bash

# Retrieve file
wget "https://docs.google.com/spreadsheets/d/15J_R5yu_9qDWeey7fRx4YH6wiRxlhW8BvFOvXpU_8qc/export?format=csv&gid=476018746" -O "content.csv"

# Arquivo CSV
csv_file="content.csv"

# Reseta workspace cadastrado para integração com a Inde
#curl -v -u admin:001q2w3e4r5t6y00 -XDELETE http://172.18.17.30:8080/geoserver/rest/workspaces/inde/datastores/inde_ds/featuretypes


# Itera sobre cada linha do CSV
while IFS=',' read -r col1 col2 col3 col4 col5 layer_name layer_title col_8 font_name col_9 col_10
do
    #
    layer_name=$(echo "$layer_name" | tr '[:upper:]' '[:lower:]')
    # Verifica se o nome da fonte é SEMA
    if [[ "$font_name" == "SEMA" ]]; then
        # Comando wget para cadastrar a layer no GeoServer
        #wget --post-data="workspace=inde&type=zcm&name=$layer_name&file=local_file_path" \
        #    --auth-no-challenge \
        #    --http-user=admin \
        #    --http-password=001q2w3e4r5t6y00 \
        #    https://pedea.sema.ce.gov.br/geoserver/rest/workspaces/inde/datastores
    curl -v -u admin:001q2w3e4r5t6y00 -XPOST -H "Content-type: text/xml" -d "<featureType><name>$layer_name</name><title>$layer_title</title></featureType>" https://pedea.sema.ce.gov.br/geoserver/rest/workspaces/inde/datastores/inde_ds/featuretypes
	curl -v -u admin:001q2w3e4r5t6y00 -XPUT -H "Content-type: text/xml" -d "<layer><defaultStyle><name>${layer_name}_style</name><workspace>inde</workspace></defaultStyle></layer>" https://pedea.sema.ce.gov.br/geoserver/rest/layers/inde:${layer_name}
    fi
done < "$csv_file"
