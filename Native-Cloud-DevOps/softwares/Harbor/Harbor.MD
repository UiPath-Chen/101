### 本地镜像推送
```bash
docker login harbor.keystone.devopscamp.us

Username: admin
Password: password123


docker buildx build \
            --push \
            --platform=linux/amd64 \
            --tag harbor.keystone.devopscamp.us/example/camp-go-example:dev-111 \
            -f Dockerfile ./
```