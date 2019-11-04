@echo off

rem apollo config db info
set apollo_config_db_url="jdbc:mysql://dev-db.joinboom.net:3306/ApolloConfigDB?characterEncoding=utf8"
set apollo_config_db_username="apollo"
set apollo_config_db_password="apollo"

rem apollo portal db info
set apollo_portal_db_url="jdbc:mysql://dev-db.joinboom.net:3306/ApolloPortalDB?characterEncoding=utf8"
set apollo_portal_db_username="apollo"
set apollo_portal_db_password="apollo"

rem meta server url, different environments should have different meta server addresses
set dev_meta="http://config-test.joinboom.com:7207"
set fat_meta="http://config-test.joinboom.com:7207"
set uat_meta="http://config-test.joinboom.com:7207"
set pro_meta="http://config-test.joinboom.com:7207"

set META_SERVERS_OPTS=-Ddev_meta=%dev_meta% -Dfat_meta=%fat_meta% -Duat_meta=%uat_meta% -Dpro_meta=%pro_meta%

rem =============== Please do not modify the following content =============== 
rem go to script directory
cd "%~dp0"

cd ..

rem package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

call mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

call mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=%apollo_portal_db_url% -Dspring_datasource_username=%apollo_portal_db_username% -Dspring_datasource_password=%apollo_portal_db_password% %META_SERVERS_OPTS%

echo "==== building portal finished ===="

pause
