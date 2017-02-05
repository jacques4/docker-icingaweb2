# icingaweb2
Docker container for icinga web2. This container includes, configures and enables modules "monitoring" and "graphite".

It also includes LDAP authentication and group assignment to icingaweb2 roles/permissions. At the moment, the group are fixed to:
 * *SEC_Icinga_Developer*: access to monitoring module, allow commenting on hosts and services, allow sending custom notifications for hosts and services
 * *SEC_Icinga_Sysadmin*: allow everything (administrator)

 Additionally, a command transport to a Icinga2 host is established via Icinga2 API. Please make sure you have set up an API user on the Icinga2 host in your _api-users.conf_.

This container only works with a MySQL/MariaDB backend.

## Environment variables
Please set all these environment variables, otherwise the docker container will not work correctly.

 * *USER_NAME_ATTRIBUTE*: attribute of the user's object in LDAP, e.g. for Windows Domain: sAMAccountName
 * *BASE_DN*: where should icingaweb2 start to search for users, who should be able to login into icingaweb2
 * *LDAP_DOMAIN*: domain or FQDN to get the domain controller or LDAP server
 * *LDAP_PORT*: 389
 * *LDAP_ROOT_DN*: root distinguished name of your LDAP server
 * *LDAP_BIND_DN*: distinguished name of the bind user to authenticate against your LDAP server
 * *LDAP_BIND_PW*: password for bind user
 * *IDO_HOST*: backend host (MySQL/MariaDB)
 * *IDO_PORT*: backend host port (e.g. 3306)
 * *IDO_DBNAME*: backend database name
 * *IDO_USERNAME*: username to authenticate against your MySQL server
 * *IDO_PASSWORD*: password to authenticate against your MySQL server
 * *API_HOST*: Icinga2 host, on which API module is enabled
 * *API_PORT*: API port, e.g. 5665
 * *API_USERNAME*: username to authenticate against the Icinga2 API
 * *API_PASSWORD*: password to authenticate against the Icinga2 API
 * *GRAPHITE_METRIC_PREFIX*: metric prefix of your graphite instance, e.g. icinga
 * *GRAPHITE_BASE_URL*: base render URL of your graphite webserver, e.g. https://graphite.example.invalid/render?


## Example docker-compose.yml

Save this as docker-compise.yml and run:
```bash
docker-compose up
```



```bash
---
web:
  image: mimacomops/icingaweb2
  ports:
    - 8080:80
  links:
    - db
  environment:
    USER_NAME_ATTRIBUTE: sAMAccountName
    BASE_DN: OU=users,DC=example,DC=invalid
    LDAP_DOMAIN: example.invalid
    LDAP_PORT: 389
    LDAP_ROOT_DN: DC=example,DC=invalid
    LDAP_BIND_DN: CN=binduser,OU=users,DC=example,DC=invalid
    LDAP_BIND_PW: someRandomBindPassword
    IDO_HOST: my-mysql-server.example.invalid
    IDO_PORT: 3306
    IDO_DBNAME: icinga
    IDO_USERNAME: icinga
    IDO_PASSWORD: someRandomMysqlPassword
    API_HOST: my-icinga2-host.example.invalid
    API_PORT: 5665
    API_USERNAME: root
    API_PASSWORD: someRandomApiPassword
    GRAPHITE_METRIC_PREFIX: icinga
    GRAPHITE_BASE_URL: https://graphite.example.invalid/render?
```


## Modules
### Icinga Director
Make sure you have set up your Icinga2 nodes correctly in order to use Icinga Director. See https://github.com/Icinga/icingaweb2-module-director/blob/master/doc/04-Getting-started.md
