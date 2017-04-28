#!/bin/sh

deploy_backend () {
  img_path="gcr.io/ieisite-163707/backend";
  path=$img_path:v$1;
  namespace=$2
  echo "Deploying backend image to namespace $2:" $path
  kubectl patch deployments backend-web-deployment -p '{"spec":{"template":{"spec":{"containers":[{"name":"backend","image":"'$path'"}]}}}}' --namespace=$namespace
  kubectl patch deployments backend-celery-deployment -p '{"spec":{"template":{"spec":{"containers":[{"name":"backend","image":"'$path'"}]}}}}' --namespace=$namespace
}

deploy_portal () {
  img_path="gcr.io/ieisite-163707/portal";
  path=$img_path:v$1;
  namespace=$2
  echo "Deploying portal image to namespace $2:" $path
  kubectl patch deployments portal-web-deployment -p '{"spec":{"template":{"spec":{"containers":[{"name":"portal","image":"'$path'"}]}}}}' --namespace=$namespace
}

if [ $1 = "backend" ]; then
  if [ $2 = "sandbox" ]; then
    if [ -z "$3" ]; then
      echo "You must specify a version"
    else
      deploy_backend $3 sandbox
    fi
  fi
  if [ $2 = "demo" ]; then
    if [ -z "$3" ]; then
      echo "You must specify a version"
    else
      deploy_backend $3 demo
    fi
  fi
  if [ $2 = "production" ]; then
    echo "Are you sure you want to deploy to production? (type y for yes)"
    read answer
    if [ $answer = "y" ]; then
      if [ -z "$3" ]; then
        echo "You must specify a version"
      else
        deploy_backend $3 production
      fi
    fi
  fi
fi

if [ $1 = "portal" ]; then
  if [ $2 = "sandbox" ]; then
    if [ -z "$3" ]; then
      echo "You must specify a version"
    else
      deploy_portal $3 sandbox
    fi
  fi
  if [ $2 = "demo" ]; then
    if [ -z "$3" ]; then
      echo "You must specify a version"
    else
      deploy_portal $3 demo
    fi
  fi
  if [ $2 = "production" ]; then
    echo "Are you sure you want to deploy to production? (type y for yes)"
    read answer
    if [ $answer = "y" ]; then
      if [ -z "$3" ]; then
        echo "You must specify a version"
      else
        deploy_portal $3 production
      fi
    fi
  fi
fi