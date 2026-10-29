## Step 4 - Give the Pods one stable address

### The problem a Service solves

Your three Pods each have their own address, but Pods are disposable. If one dies, its replacement gets a **new** address. A program that wanted to talk to your web server would have to keep chasing those changing addresses. A **Service** fixes this. It has one name and one address that never change, and it forwards each request to whichever Pods are currently healthy.

### Read the YAML first

```
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
```

**Line by line:**

- `apiVersion: v1` and `kind: Service`: this is a Service, which belongs to the core group of Kubernetes objects (hence just `v1`).
- `name: web-service` is the name other programs will use to reach it. Remember it, because you will call it by exactly this name.
- `type: ClusterIP` means the Service gets an address that works **only inside the cluster**. Other types, such as NodePort and LoadBalancer, open it to the outside world. ClusterIP is the default and the safest.
- `selector: app: web-app` is the key line. It says "my backends are every Pod that carries the label `app=web-app`". This is the same label you stuck on the Pods in the Deployment. **This is the link between the Service and the Pods**, and it is made only by matching labels, not by names.
- `port: 80` is the port **the Service listens on**. Clients call `web-service` on port 80.
- `targetPort: 80` is the port **on the Pod** that traffic is forwarded to, where Nginx is listening. They happen to match here, but they can differ, for example a Service on 80 forwarding to an app on 8080. A wrong `targetPort` is another very common real-world fault.

### Create it

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

**What you should see:**

```
service/web-service created
```

### Look at the Service

```plain
kubectl get service -n learning
```{{exec}}

```
NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
web-service   ClusterIP   10.96.x.x      <none>        80/TCP    10s
```

**How to read it.** `CLUSTER-IP` is the Service's permanent internal address (yours will differ). `EXTERNAL-IP <none>` confirms it is not exposed outside the cluster. `80/TCP` is the port and the protocol (TCP, the reliable-delivery method that web traffic uses).

### The most important command in this lab

```plain
kubectl get endpoints web-service -n learning
```{{exec}}

**What it does.** An **endpoint** is the address of one Pod that the Service forwards to. This command shows the Service's current list of backends. Kubernetes builds that list automatically by finding Pods whose labels match the Service's selector.

**What you should see:**

```
NAME          ENDPOINTS                                         AGE
web-service   192.168.1.4:80,192.168.1.5:80,192.168.2.3:80      15s
```

Your newer Kubernetes may print a warning first that `v1 Endpoints is deprecated`. That is only a notice that a newer object type called EndpointSlice is replacing it. The information is the same.

**How to read it.** There are three addresses, each ending in `:80`. **Compare them with the Pod addresses from the previous step. They are the same three addresses.** That is the whole mechanism: the Service did not copy the Pods or know them by name. It searched for Pods with `app=web-app` and listed their addresses.

If this column said `<none>`, the Service would have no backends and every request would fail. You will cause exactly that in a later step, so remember what the healthy version looks like.

Click **Check** when you can see three endpoints.
