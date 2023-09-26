kubectl delete deployment admin-server
kubectl delete deployment api-gateway
kubectl delete deployment config-server
kubectl delete deployment customers-service
kubectl delete deployment discovery-server
kubectl delete deployment vets-service  
kubectl delete deployment visits-service

kubectl delete service admin-server
kubectl delete service api-gateway
kubectl delete service config-server
kubectl delete service customers-service
kubectl delete service discovery-server
kubectl delete service vets-service  
kubectl delete service visits-service

cd /workspaces/java-microservices-aks-lab/src
mvn clean package -DskipTests

cd /workspaces/java-microservices-aks-lab/src/staging-acr

cp ../spring-petclinic-api-gateway/target/spring-petclinic-api-gateway-$VERSION.jar spring-petclinic-api-gateway-$VERSION.jar
cp ../spring-petclinic-admin-server/target/spring-petclinic-admin-server-$VERSION.jar spring-petclinic-admin-server-$VERSION.jar
cp ../spring-petclinic-customers-service/target/spring-petclinic-customers-service-$VERSION.jar spring-petclinic-customers-service-$VERSION.jar
cp ../spring-petclinic-visits-service/target/spring-petclinic-visits-service-$VERSION.jar spring-petclinic-visits-service-$VERSION.jar
cp ../spring-petclinic-vets-service/target/spring-petclinic-vets-service-$VERSION.jar spring-petclinic-vets-service-$VERSION.jar
cp ../spring-petclinic-config-server/target/spring-petclinic-config-server-$VERSION.jar spring-petclinic-config-server-$VERSION.jar
cp ../spring-petclinic-discovery-server/target/spring-petclinic-discovery-server-$VERSION.jar spring-petclinic-discovery-server-$VERSION.jar

docker build -t $MYACR.azurecr.io/spring-petclinic-api-gateway:$VERSION \
    --build-arg ARTIFACT_NAME=spring-petclinic-api-gateway-$VERSION.jar \
    --build-arg APP_PORT=8080 \
    .

docker push $MYACR.azurecr.io/spring-petclinic-api-gateway:$VERSION

docker build -t $MYACR.azurecr.io/spring-petclinic-admin-server:$VERSION \
    --build-arg ARTIFACT_NAME=spring-petclinic-admin-server-$VERSION.jar \
    --build-arg APP_PORT=8080 \
    .

docker push $MYACR.azurecr.io/spring-petclinic-admin-server:$VERSION

docker build -t $MYACR.azurecr.io/spring-petclinic-customers-service:$VERSION \
    --build-arg ARTIFACT_NAME=spring-petclinic-customers-service-$VERSION.jar \
    --build-arg APP_PORT=8080 \
    .

docker push $MYACR.azurecr.io/spring-petclinic-customers-service:$VERSION

docker build -t $MYACR.azurecr.io/spring-petclinic-visits-service:$VERSION \
    --build-arg ARTIFACT_NAME=spring-petclinic-visits-service-$VERSION.jar \
    --build-arg APP_PORT=8080 \
    .

docker push $MYACR.azurecr.io/spring-petclinic-visits-service:$VERSION

docker build -t $MYACR.azurecr.io/spring-petclinic-vets-service:$VERSION \
    --build-arg ARTIFACT_NAME=spring-petclinic-vets-service-$VERSION.jar \
    --build-arg APP_PORT=8080 \
    .
docker push $MYACR.azurecr.io/spring-petclinic-vets-service:$VERSION

docker build -t $MYACR.azurecr.io/spring-petclinic-config-server:$VERSION \
    --build-arg ARTIFACT_NAME=spring-petclinic-config-server-$VERSION.jar \
    --build-arg APP_PORT=8888 \
    .

docker push $MYACR.azurecr.io/spring-petclinic-config-server:$VERSION

docker build -t $MYACR.azurecr.io/spring-petclinic-discovery-server:$VERSION \
    --build-arg ARTIFACT_NAME=spring-petclinic-discovery-server-$VERSION.jar \
    --build-arg APP_PORT=8761 \
    .

docker push $MYACR.azurecr.io/spring-petclinic-discovery-server:$VERSION


cd /workspaces/java-microservices-aks-lab/kubernetes

kubectl config set-context --current --namespace=$NAMESPACE

kubectl apply -f spring-petclinic-config-server.yml
kubectl get pods -w

kubectl apply -f spring-petclinic-discovery-server.yml
kubectl get pods -w

kubectl apply -f spring-petclinic-customers-service.yml
kubectl apply -f spring-petclinic-visits-service.yml
kubectl apply -f spring-petclinic-vets-service.yml
kubectl apply -f spring-petclinic-api-gateway.yml
kubectl apply -f spring-petclinic-admin-server.yml

kubectl get services -n spring-petclinic