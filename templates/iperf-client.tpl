---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "iperf"
  replicas: 2
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "iperf"
    spec:
      serviceAccount: nsc-acc
      containers:
        - name: iperf3-client
          image: {{ .Values.registry }}/infrabuilder/netbench:server-iperf3
          command:
          - tail
          - -f
          - /dev/null
          securityContext:
            capabilities:
              add: ["NET_ADMIN", "NET_RAW"]
metadata:
  name: iperf
  namespace: {{ .Release.Namespace }}
  annotations:
    ns.networkservicemesh.io: iperf?app=iperf
