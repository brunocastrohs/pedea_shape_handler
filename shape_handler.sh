::1

rename 'y/A-Z/a-z/' *

for file in *.shp; do echo "DROP TABLE  zcm.\"${file%.shp}\"" >  "${file%.shp}".sql; done;

for file in *.shp; do psql -d "host=172.18.17.38 port=5432 dbname=pedea user=postgres password=001q2w3e00" -f "${file%.shp}".sql > nul; done;

::2

for file in *.shp; do shp2pgsql -s 4674 "$file" zcm."${file%.shp}" > "${file%.shp}".sql; done;

for file in *.sql; do psql -d "host=172.18.17.38 port=5432 dbname=pedea user=postgres password=001q2w3e00" -f "$file" > nul; done;

::10
for file in *.sql; do curl -v -u admin:001q2w3e4r5t6y00 -XPOST -H "Content-type: text/xml" -d "<style><name>${file%.sql}_style</name><filename> ${file%.sql}.sld </filename></style>" http://172.18.17.38:8080/geoserver/rest/workspaces/zcm/styles; done;

::11
for file in *.sql; do curl -v -u admin:001q2w3e4r5t6y00 -XPUT -H "content-type: application/vnd.ogc.se+xml" -d @${file%.sql}.sld http://172.18.17.38:8080/geoserver/rest/workspaces/zcm/styles/${file%.sql}_style; done;

::12
for file in *.sql; do curl -v -u admin:001q2w3e4r5t6y00 -XPOST -H "Content-type: text/xml" -d "<featureType><name>${file%.sql}</name></featureType>" http://172.18.17.38:8080/geoserver/rest/workspaces/zcm/datastores/zcm_ds/featuretypes; done;

::13
for file in *.sql; do curl -v -u admin:001q2w3e4r5t6y00 -XPUT -H "Content-type: text/xml" -d "<layer><defaultStyle><name>${file%.sql}_style</name><workspace>zcm</workspace></defaultStyle></layer>" http://172.18.17.38:8080/geoserver/rest/layers/zcm:${file%.sql}; done;

::14
for file in *.sql; do content=$(curl -s -u admin:001q2w3e4r5t6y00 http://172.18.17.38:8080/geoserver/rest/workspaces/zcm/styles/${file%.sql}_style.sld); if [ -z "$content" ] || [ ${#content} -lt 50 ]; then echo "⚠️  SLD vazio ou inválido: ${file%.sql}_style"; fi; done


::15
for file in *.sql; do status=$(curl -s -o /dev/null -w "%{http_code}" -u admin:001q2w3e4r5t6y00 http://172.18.17.38:8080/geoserver/rest/layers/zcm:${file%.sql}); if [ "$status" -ne 200 ]; then echo "❌ Camada não funcional: zcm:${file%.sql} (HTTP $status)"; else echo "✅ Camada funcional: zcm:${file%.sql}"; fi; done
