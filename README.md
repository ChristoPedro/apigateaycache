# Terraform OCI API Gateway Cache Com Redis

API Gateway além de ser utilizado para centralizar e padronizar os APIs de diversos sistemas do backend, também pode tem a capacidade de reduzir a quantidade de chamada realizada ao backend. Tanto validando os requisitos necessários de cada chamada, como HEAD, BODY e QUERY ou através de cache para determinadas chamadas que são realizadas com frequência.

No API Gateway do OCI, é possível construir uma arquitetura onde se utiliza um banco Redis stand anlone para guardar o cache das chamadas, assim quando uma chamada recorrente é solicitada durante o tempo de TTL na rota, ela é tratada na camada do API Gateway e não do Backend, reduzindo assim a quantidade de dados processados e o tempo de resposta das APIs.

## Diagrama da Arquitetura

Nessa arquitetura o API Gateway acessa o Redis através da VCN e se autentica com a senha que obtém através do secret que está armazenado no Vault do OCI.

## Pré requisitos

- Permissão para `gerenciar` os seguintes recuros na tenancy do OCI: `vcns`, `internet-gateway`, `route-tables`, `nat-gateway`, `service-gateway`, `security-lists`, `subnets`, `intances`, `private-endpoint`, `api-gateway`, `kms-vault`, `kms-key` and `kms-secrets`.

- Limite de recursos para criar: 1 VCN, 2 Subnets, 1 Internet Gateway, 1 Nat Gateay, 1 Service Gateway, 2 Route Tables, 2 Security Lists, 1 compute instance, 1 Private Endpoint,1 API Gateway, 1 Vault, 1 Vault Key and 1 Vault Secret.

- Se não tiver os limites ou permissões necessários é possivel utilizar VCN, API Gateway, Private Endpoint e Vault já criados. Ou contate o admistrador da sua tenancy para conseguir acesso ou mais recursos.

## Deploy com Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/ChristoPedro/apigatewaycache/releases/download/latest/ApiGatewayCache.zip)
