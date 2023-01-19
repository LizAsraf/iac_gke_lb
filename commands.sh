#!/bin/bash
gcloud container clusters get-credentials oceanic-works-374915-gke --region us-central1 --project oceanic-works-374915
gcloud auth login
echo "please authenticate in the link above"
gcloud auth activate-service-account k8s-staging --key-file=${HOME}/key.json
gcloud auth configure-docker
echo "cloning the repository for the helm instalation please be patient"
git clone https://github.com/LizAsraf/helm_publisher_listener
echo "clone completed"
cd helm_publisher_listener
echo "install publish application and the dependencies"
helm install service-a ./serviceA
echo "instalation completed"
echo "install listener application and the dependencies"
helm install service-b ./serviceB
echo "instalation completed"
echo "creating gcr pull secret"
kubectl create secret docker-registry gcr-pull-secret \
 --docker-server=https://gcr.io --docker-username=_json_key \
 --docker-password="$(cat service_account_keys.json)"\
--docker-email='k8s-staging@oceanic-works-374915.iam.gserviceaccount.com'
echo "creating gke cloud sql secret"
kubectl create secret generic gke-cloud-sql-secrets  \
  --from-literal=database=messages \
  --from-literal=username=postgres \
  --from-literal=password=postgres
echo "creating key for the kubernetes service account"
gcloud iam service-accounts keys create ~/key.json \
--iam-account=k8s-staging@oceanic-works-374915.iam.gserviceaccount.com
echo "creating kubernetes service account secret"
kubectl create secret generic kubernetes-service-account \
--from-file=service_account.json=${HOME}/key.json
helm upgrade service-a ./serviceA
helm upgrade service-b ./serviceB