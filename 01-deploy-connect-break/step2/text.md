## Step 2 - Give them a Service and call it

The Pods exist, but each has its own short-lived address. Create a Service so clients have one stable name:

```plain
cat > service.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: learning
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
    - port: 80
      targetPort: 80
EOF
kubectl apply -f service.yaml
```{{exec}}

What this says:
- `ClusterIP` means the Service is reachable only from inside the cluster.
- `selector: app: web-app` means "forward to every Pod that carries the label `app=web-app`".
- `port: 80` is the port clients call on the Service; `targetPort: 80` is the port Nginx listens on inside the Pod.

Start a small test client Pod that just sleeps, so you can run commands from inside the cluster:

```plain
kubectl run client -n learning --image=curlimages/curl --restart=Never --command -- sleep 3600
kubectl wait -n learning --for=condition=Ready pod/client --timeout=90s
```{{exec}}

Call the Service by name. Inside the cluster, **CoreDNS** (the cluster's internal name lookup) turns `web-service` into the Service's address:

```plain
kubectl exec -n learning client -- curl -sI http://web-service
```{{exec}}

You should see `HTTP/1.1 200 OK`. Click **Check**.
