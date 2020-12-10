---
apiVersion: apps/v1
kind: Deployment
spec:
  selector:
    matchLabels:
      networkservicemesh.io/app: "iperf"
      networkservicemesh.io/impl: "iperf"
  replicas: 1
  template:
    metadata:
      labels:
        networkservicemesh.io/app: "iperf"
        networkservicemesh.io/impl: "iperf"
    spec:
      serviceAccount: nse-acc
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: networkservicemesh.io/app
                    operator: In
                    values:
                      - iperf
                  - key: networkservicemesh.io/impl
                    operator: In
                    values:
                      - iperf
              topologyKey: "kubernetes.io/hostname"
      containers:
        - name: iperf-nse
          image: {{ .Values.registry }}/{{ .Values.org }}/test-common:{{ .Values.tag}}
          command: ["/bin/icmp-responder-nse"]
          imagePullPolicy: {{ .Values.pullPolicy }}
          env:
            - name: ADVERTISE_NSE_NAME
              value: "iperf"
            - name: ADVERTISE_NSE_LABELS
              value: "app=iperf"
            - name: IP_ADDRESS
              value: "172.16.1.0/24"
          resources:
            limits:
              networkservicemesh.io/socket: 1
        - name: iperf-server
          image: {{ .Values.registry }}/infrabuilder/netbench:server-iperf3
          args:
          - iperf3
          - -s  
          securityContext:
            capabilities:
              add: ["NET_ADMIN", "NET_RAW"]
metadata:
  name: iperf-nse
  namespace: {{ .Release.Namespace }}
