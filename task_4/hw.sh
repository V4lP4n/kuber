#!/bin/bash
users=(deploy_view deploy_edit prod_admin prod_view)

for i in ${users[@]}
  do
    openssl genrsa -out $i.key 2048
    
    openssl req -new -key $i.key \
    -out $i.csr \
    -subj "/CN=$i"
    
    openssl x509 -req -in $i.csr \
    -CA ~/.minikube/ca.crt \
    -CAkey ~/.minikube/ca.key \
    -CAcreateserial \
    -out $i.crt -days 500

    kubectl config set-credentials $i \
    --client-certificate=$i.crt \
    --client-key=$i.key


    kubectl config set-context $i \
    --cluster=minikube --user=$i

  done