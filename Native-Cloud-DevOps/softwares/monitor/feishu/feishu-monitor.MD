
>业务代码 > Jenkinsfile > 添加stage
https://liguoqinjim.cn/post/tool/%E4%BD%BF%E7%94%A8%E9%A3%9E%E4%B9%A6%E5%88%9B%E5%BB%BA%E8%87%AA%E5%B7%B1%E7%9A%84%E9%80%9A%E7%9F%A5%E6%9C%BA%E5%99%A8%E4%BA%BA/

```yaml
        stage('FeiShu NOTICE') {
            agent {
                kubernetes {
                    defaultContainer 'curl'
                    yaml """
kind: Pod
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: curl
    image: curlimages/curl
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 99d
"""
                }
            }

            environment {
              JOB_NAME = "${env.JOB_NAME}"
            }

            steps {
                container(name: 'curl', shell: '/bin/sh') {
                    sh '''#!/bin/sh
                        curl -L -X POST 'https://open.feishu.cn/open-apis/bot/v2/hook/ef8d8610-7ab9-4db5-99f4-edfe815096ef' -H "Content-Type: application/json" -d '{"msg_type":"text","content":{"text":"'$JOB_NAME' Build Successfully"}}'
                    '''
                }
            }
        }
```

### alarm.sh
---
```bash
#! /bin/bash

# 飞书机器人webhook 地址
Webhook=https://www.feishu.cn/flow/api/trigger-webhook/97c6bb1b06b555c2e26abbd51955fbcc

# 1. 磁盘空间
DiskSpace=$(df -h |grep /$ | awk '{print $5}')

curl -X POST \
${Webhook} \
-H 'Content-Type: application/json' \
-d '{
    "item": "花生好车磁盘空间预警",
    "data": "'${DiskSpace}'"
```