### Overview 

Kali ini saya akan membuat sebuah page baru khusus untuk case atau kasus pada setiap infrastructure yang sudah saya bangun sebelumnya,jadi pada case page ini berisi 
projek saya yang mengotak-atik infrastructure yang sudah dibangun entah itu menambahkan beban,menambahkan cluster,atau melakukan horizontal scaling atau vertikal scaling,
di projek kali ini saya akan menambahkan 1 cluster lagi atau scale cluster yang sudah pernah yaitu "Hybrid Cloud-Native Infrastructure",dan bukan hanya menambah cluster 
tapi juga untuk bot telegram di tambahkan sesuai dengan cluster yang ditambah,langsung saja masuk ke pembahasannya

| Node        | CPU     | RAM  | Storage | Network                                             |
|-------------|---------|------|---------|---------------------------------------------------- |
| **Master-cluster-Jakarta**  | 2 cores | 2GB  | 10GB    | 1 Adapters   ( DHCP Ip )            |
| **Worker 1-cluster-Jakarta**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( DHCP Ip )            |
| **Worker 2-cluster-Jakarta**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( DHCP Ip )            |
| **Master-cluster-Bandung**  | 2 cores | 2GB  | 10GB    | 1 Adapters   ( DHCP Ip )            |
| **Worker 1-cluster-Bandung**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( DHCP Ip )            |
| **Worker 2-Cluster-Bandung**| 2 cores | 2GB  | 10GB    | 1 Adapters   ( DHCP Ip )            |
| **Jenkins**                 | 7 cores | 7GB  | 240GB   |                Wlan                 |

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
├── lambda_function_alert.py
├── lambda_function_consumer.py
├── lambda_function.py
├── lambda-permission.tf
├── lambda.tf
├── lambda-alert.tf
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
├── playbook-ip.yaml
├── playbook-join.yaml
├── playbook-install-java-baremetal.yaml
├── playbook-install-jenkins-baremetal.yaml
├── playbook-install-kubectl-baremetal.yaml
├── playbook-install-terraform-baremetal.yaml
├── playbook-kubernetes.yaml
├── playbook-pkg.yaml
├── playbook-swap.yaml
├── playbook-config.yaml
├── observ.yaml
├── observ_2.yaml
├── service-account.yaml
├── clusterrole.yaml
├── role-binding.yaml
├── secret-token.yaml
├── kubeconfig.sh
```

dan yang terakhir yang ketiga di cluster 

```
cluster-side/
├── alertmanager-telegram.yaml
```

### Tools
Untuk Tools Masih sama karena ini menggunakan infrastructure yang sudah dibuat sebelumnya jadinya tidak ada perubahan dalam penggunaan tools 

### Reasoning
Kenapa saya memilih untuk menambahkan cluster? Awalnya saya hanya ingin menerapkan konsep RBAC ke infrastructure yang sudah dibangun. Tapi saya berpikir, untuk 1 cluster 
saja, penerapan RBAC-nya tidak terlalu menantang — sebatas membuat manifest dan apply ke satu API server. Karena itu saya putuskan untuk sekaligus menambahkan cluster 
baru, supaya saya juga bisa membuktikan pemahaman bahwa RBAC itu scoped per-cluster — tidak ada RBAC cross-cluster bawaan Kubernetes, jadi config harus dipisah dan 
diterapkan independen ke masing-masing cluster. Saya pakai blueprint infrastructure yang sama untuk kedua cluster, supaya perbandingan penerapan RBAC-nya konsisten dan 
environment-nya apple-to-apple.

### prerequisites
**NOTE!!! BANYAK FILE-FILE CONFIG YANG SAMA DENGAN PROJEK INFRA YANG MENJADI DASAR DAN SEMUA 
KONDISI HARUS BENAR-BENAR SAMA ENTAH ITU SSH ATAU SETIAP CONFIG**
Ada beberapa hal sebelum memulai,hal yang perlu di check dan di verfikasi bahwa sudah ada sebelum masuk ke bagian setup
- **LAPTOP 2**   : Di laptop 2 harus sudah terinstall jenkins(jenkins bertindak full sebagai Ci/Cd) dan terraform
- **LOCALSTACK** : Localstack sudah harus terinstall di laptop 2
- **MANIFEST**   : Ada banyak file disini seperti .tf , .yaml ,dan file helm jadinya harus sudah ada manifest dari project dasarnya
- **WSL**        : Di wsl yang berjalan di laptop 1 sudah harus terinstall KVM/QEMU

Untuk project dasarnya ada disini [link](https://rizkiyusupk.github.io/devops/clouds/linux/server/iac/infrastructure/aws-2/),baca sampai selesai!!! karena
