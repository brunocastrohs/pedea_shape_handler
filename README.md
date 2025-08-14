🗺️ Banco de Dados Padronizado e Atualizado da PEDEA

Este repositório contém scripts Bash para automatizar a padronização, ingestão e publicação de dados geoespaciais no GeoServer e no banco de dados PostgreSQL/PostGIS da PEDEA, alinhados à auditoria e integração com a Infraestrutura Nacional de Dados Espaciais (INDE).

O objetivo é garantir que as camadas geográficas estejam sempre padronizadas, atualizadas e acessíveis via GeoServer, conforme as diretrizes do projeto PEDEA.

📂 Estrutura do Repositório

inde_importer.sh → Importa e publica camadas no workspace INDE do GeoServer.

pedea_importer.sh → Importa e publica camadas no workspace PEDEA (zcm) do GeoServer.

shape_handler.sh → Processa arquivos shapefile, faz ingestão no PostGIS e publica estilos e camadas no GeoServer.

⚙️ Pré-requisitos

PostgreSQL com PostGIS instalado e configurado

GeoServer com autenticação habilitada

Ferramentas CLI:

wget

curl

psql

shp2pgsql

rename

📥 Fluxo de Execução
1. Importação de Camadas da INDE
./inde_importer.sh


Baixa um CSV do Google Sheets com metadados das camadas.

Filtra camadas da fonte SEMA.

Cria featureType e define estilo padrão no workspace INDE (inde_ds).

2. Importação de Camadas PEDEA
./pedea_importer.sh


Baixa o mesmo CSV de metadados.

Cria featureType e define estilo padrão no workspace PEDEA (zcm_ds).

3. Processamento de Shapefiles
./shape_handler.sh


O script contém blocos numerados (::1, ::2, etc.) para execução modular:

Renomear arquivos para minúsculas e excluir tabelas antigas no PostGIS.

Carregar shapefiles no banco pedea (zcm schema).

Criar estilos SLD no GeoServer.

Enviar arquivos SLD para o GeoServer.

Registrar featureType no workspace zcm.

Definir estilo padrão para cada camada.

Validar estilos (detectar SLD vazio/inválido).

Validar camadas publicadas (checar HTTP status).

📊 Relação com o Card PEDEA

Este repositório implementa os seguintes pontos do checklist do card Banco de dados padronizado e atualizado da PEDEA:

✅ Auditoria e padronização da estrutura de dados geoespaciais

⚙️ Implementação de rotinas automatizadas de ingestão de dados

📡 Publicação e configuração automática no GeoServer

🔐 Segurança

Atenção:
As credenciais (admin:senha, postgres:senha) estão hardcoded nos scripts para ambiente interno controlado.
Para produção, utilize variáveis de ambiente ou arquivos .env fora do repositório.

📌 Observações

Todos os scripts devem ser executados no mesmo ambiente de rede do servidor GeoServer/PostGIS.

O CSV de origem deve estar com as colunas de nomes e títulos corretos.

O carregamento de shapefiles assume o SRID 4674 (SIRGAS 2000).

