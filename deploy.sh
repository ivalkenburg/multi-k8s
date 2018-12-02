#!/bin/bash

docker build -t lolrogi/multi-client:latest -t lolrogi/multi-client:$GIT_SHA ./client
docker build -t lolrogi/multi-server:latest -t lolrogi/multi-server:$GIT_SHA ./server
docker build -t lolrogi/multi-worker:latest -t lolrogi/multi-worker:$GIT_SHA ./worker

docker push lolrogi/multi-client:latest
docker push lolrogi/multi-server:latest
docker push lolrogi/multi-worker:latest
docker push lolrogi/multi-client:$GIT_SHA
docker push lolrogi/multi-server:$GIT_SHA
docker push lolrogi/multi-worker:$GIT_SHA

kubectl apply -f ./k8s
kubectl set image deployments/server-deployment server=lolrogi/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=lolrogi/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=lolrogi/multi-worker:$GIT_SHA