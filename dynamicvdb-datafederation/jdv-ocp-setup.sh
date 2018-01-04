#!/bin/bash
echo 'Logging into oc tool as admin'
oc login -u admin -p admin
echo 'Switching to the openshift project'
oc project openshift
echo 'Creating the image stream for the OpenShift datavirt image'
oc delete is jboss-datavirt63-openshift
oc create -f https://raw.githubusercontent.com/cvanball/jdv-ose-demo/master/extensions/is.json
echo 'Creating the s2i quickstart template. This will live in the openshift namespace and be available to all projects'
oc delete template datavirt63-ext-mysql-psql-s2i
oc create -n openshift -f https://raw.githubusercontent.com/cvanball/jdv-ose-demos/master/templates/datavirt63-ext-mysql-psql-s2i.json
oc login -u developer -p developer
echo 'Creating a new project called jdv-datafederation-demo'
oc new-project jdv-datafederation-demo
echo 'Creating a service account and accompanying secret for use by the datavirt application'
oc create -f https://raw.githubusercontent.com/cvanball/jdv-ose-demos/master/dynamicvdb-datafederation/mysql-postgresql-driver-image/datavirt-app-secret.yaml
echo 'Add the role view to the service account under which the pod is running'
oadm policy add-role-to-user view system:serviceaccount:jdv-datafederation-demo:datavirt-service-account
echo 'Retrieving datasource properties (market data flat file and country list web service hosted on public internet)'
curl https://raw.githubusercontent.com/cvanball/jdv-ose-demos/master/dynamicvdb-datafederation/mysql-postgresql-driver-image/datasources.properties -o datasources.properties
echo 'Creating a secret around the datasource properties'
oc secrets new datavirt-app-config datasources.properties
echo 'Deploying JDV quickstart template with default values'
oc new-app --template=datavirt63-ext-mysql-psql-s2i
echo '==============================================='
echo 'The following urls will allow you to access the Financials VDB via OData4:'
echo '==============================================='
echo "http://datavirt-app-jdv-datafederation-demo.$(minishift ip).nip.io/odata4/Financials/All_Customers/CUSTOMER?$format=json"
