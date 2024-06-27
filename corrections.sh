sudo vim /etc/prometheus/prometheus.yml


- job_name: node_export
    static_configs:
      - targets: ["localhost:9100"]

      
- job_name: 'jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['<jenkins-ip>:8080']





promtool check config /etc/prometheus/prometheus.yml

curl -X POST http://localhost:9090/-/reload