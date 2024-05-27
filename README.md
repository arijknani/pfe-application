********CASC********
oc  create configmap oc-casc  --from-file=oc/bundle.yaml  --from-file=oc/items.yaml  --from-file=oc/jenkins.yaml  --from-file=oc/plugins.yaml

helm install cloudbees-ci cloudbees/cloudbees-core  --set OperationsCenter.HostName='oc.apps.ocp4.smartek.ae' --set OperationsCenter.Route.tls.Enable=true --values values.yaml
********DATA*********
mysql-database: 

mysql-user:

mysql-password:

db-password: 

db-username: 

db-url: jdbc:mysql://mysql:3306/


********MYSQL deployment*********

vi mysql-secrets.yaml

oc apply -f mysql-secrets.yaml

oc apply -f mysql-storage.yaml

**MYSQL CONTAINER**
oc delete all -l app=mysql

oc new-app mysql:latest --name=mysql 

oc logs 

**ENV**

oc set env --from=secret/mysql-secrets  deployment/mysql

**VOLUME**

oc set volume deployment/mysql --add --name=mysql --type=persistentVolumeClaim --claim-name=mysql-pv-claim --mount-path=/var/lib/mysql


**TEST**
oc logs

oc rsh  

oc exec --stdin --tty mysql-container-684c655b64-2wqkb -- /bin/bash

use appdb;

mysql -u arij -p

oc get deployment mysql-container -o yaml

oc get pvc 

oc get pv 

oc get pods 


********SPRING BOOT deployment*********

**SECRETS**
vi app-secrets.yaml

oc apply -f app-secrets.yaml
oc get secret app-secrets -o yaml

**CONFIG MAP**
vi app-configmap.yaml

oc apply -f app-configmap.yaml

oc get configmap app-configmap -o yaml


**SPRINGBOOT CONTAINER**

oc delete all -l app=springboot-container

oc new-app https://github.com/arijknani/containerized-app.git#docker-build --name=springboot-container --strategy=docker

**ENV**
oc set env --from=secret/app-secrets  deployment/springboot-container

oc set env --from=configmap/app-configmap  deployment/springboot-container

oc expose service/springboot-container

oc get deployment springboot-container -o yaml

oc logs springboot-container-1-build

oc get routes ==>  http://springboot-container-arij-project.apps.ocp4.smartek.ae






