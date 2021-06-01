# K8S Custom Default Backend

## Build instructions

1. Run docker build

```bash
docker build -t some_tag --build-arg REDIRECT_URL=https://some-url.com .
```

2. Push image to registry

```bash
docker push some_registry/k8s-custom-default-backend:some_tag
```

<br/>

## Usage instructions

1. Create manifest (custom_default_backend.yaml)

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: custom-default-backend
  namespace: kube-system
  labels:
    app.kubernetes.io/name: custom-default-backend
    app.kubernetes.io/part-of: ingress-nginx
spec:
  selector:
    app.kubernetes.io/name: custom-default-backend
    app.kubernetes.io/part-of: ingress-nginx
  ports:
  - port: 80
    targetPort: 80
    name: http
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: custom-default-backend
  namespace: kube-system
  labels:
    app.kubernetes.io/name: custom-default-backend
    app.kubernetes.io/part-of: ingress-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: custom-default-backend
      app.kubernetes.io/part-of: ingress-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: custom-default-backend
        app.kubernetes.io/part-of: ingress-nginx
    spec:
      containers:
      - name: custom-default-backend
        image: some_registry/k8s-custom-default-backend:some_tag
        imagePullPolicy: Always
        ports:
        - containerPort: 80
```

2. Kubectl create the manifest

```bash
kubectl create -f custom_default_backend.yaml
```

3. Delete previous Nginx Ingress Controller Helm installation

```bash
helm delete nginx-ingress -n ingress-nginx
```

4. Reinstall

```bash
helm install nginx-ingress --namespace kube-system ingress-nginx/ingress-nginx --set defaultBackend.enabled=false,controller.defaultBackendService=ingress-nginx/custom-default-backend
```
