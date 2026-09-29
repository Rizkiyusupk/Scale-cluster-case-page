Kali ini saya akan membuat sebuah page baru khusus untuk case atau kasus pada setiap infrastructure yang sudah saya bangun sebelumnya,jadi pada case page ini berisi 
projek saya yang mengotak-atik infrastructure yang sudah dibangun entah itu menambahkan beban,menambahkan cluster,atau melakukan horizontal scaling atau vertikal scaling,
di projek kali ini saya akan menambahkan 1 cluster lagi atau scale cluster yang sudah pernah yaitu "Hybrid Cloud-Native Infrastructure",dan bukan hanya menambah cluster 
tapi juga untuk bot telegram di tambahkan sesuai dengan cluster yang ditambah,**NOTE!!! BANYAK FILE-FILE CONFIG YANG SAMA DENGAN PROJEK INFRA YANG MENJADI DASAR DAN SEMUA 
KONDISI HARUS BENAR-BENAR SAMA ENTAH ITU SSH ATAU SETIAP CONFIG,MAKA DARI ITU DIHARAPKAN MEMBACA TERLEBIH DAHULU PROJEK Hybrid Cloud-Native Infrastructure** jika ingin 
baca [klik disini](https://rizkiyusupk.github.io/devops/clouds/linux/server/iac/infrastructure/aws-2/),langsung saja masuk ke pembahasannya

| Node        | CPU     | RAM  | Storage | Network                                             |
|-------------|---------|------|---------|---------------------------------------------------- |
| **Master-cluster-Jakarta**  | 2 cores | 2GB  | 10GB    | 1 Adapters   ( Static Ip )          |
| **Worker 1-cluster-Jakarta**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( Static Ip )          |
| **Worker 2-cluster-Jakarta**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( Static Ip )          |
| **Master-cluster-Bandung**  | 2 cores | 2GB  | 10GB    | 1 Adapters   ( Static Ip )          |
| **Worker 1-cluster-Bandung**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( Static Ip )          |
| **Worker 2-Cluster-Bandung**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( Static Ip )          |
| **Jenkins**                 | 7 cores | 7GB  | 240GB   |                Wlan                 |

![aevferb](/asset/work.png)

### STRUCTURE FOLDER 

Untuk structure folder yang digunakan dalam projek ini ada tiga yang pertama itu untuk terraform dan yang kedua itu ansible,terakhir itu ada di cluster,

```
terraform-setup/
├── compute.tf
├── main.tf
├── prep-vm.tf
├── s3.tf
├── sns.tf
├── sqs.tf
├── sqs-trigger-lambda.tf
├── iam-attachment-role.tf
├── iam-attachment-role-consumer.tf
├── lambda_function_consumer.py
├── lambda_function.py
├── lambda-permission.tf
├── lambda.tf
├── lambda-2.tf
├── cloud-watch.tf
├── cloud-watch-metrics.tf
├── dynamodb.tf
├── compute-cluster-2.tf
├── prep-2.tf
```

lalu yang kedua

```
k8s/
├── ansible.cfg
├── inventory
├── playbook-allow-port.yaml
├── playbook-enable-service-baremetal.yaml
├── playbook-ip.yaml
├── playbook-install-java-baremetal.yaml
├── playbook-install-jenkins-baremetal.yaml
├── playbook-install-kubectl-baremetal.yaml
├── playbook-join.yaml
├── playbook-kubernetes.yaml
├── playbook-pkg.yaml
├── playbook-swap.yaml
├── playbook-config.yaml
├── playbook-install-terraform-bare-metal.yaml
├── observ.yaml
├── observ_2.yaml
```

dan yang terakhir yang ketiga di cluster 

```
cluster-side/
├── alertmanager-telegram.yaml
```
