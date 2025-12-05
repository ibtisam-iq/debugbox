
```bash
admin@docker-host ➜  docker build -t abc .
[+] Building 2296.3s (5/9)                                                                                                                                  docker:default
 => [internal] load build definition from Dockerfile                                                                                                                  0.0s
 => => transferring dockerfile: 2.29kB                                                                                                                                0.0s
 => [internal] load metadata for docker.io/library/alpine:3.20                                                                                                       30.2s
 => [internal] load .dockerignore                                                                                                                                     0.0s
 => => transferring context: 2B                                                                                                                                       0.0s
 => [1/6] FROM docker.io/library/alpine:3.20@sha256:765942a4039992336de8dd5db680586e1a206607dd06170ff0a37267a9e01958                                                  0.3s
 => => resolve docker.io/library/alpine:3.20@sha256:765942a4039992336de8dd5db680586e1a206607dd06170ff0a37267a9e01958                                                  0.0s
 => => extracting sha256:5311e7f182d02360a7194aa2995849bcdf04795c39a0ffdcf413eae625865970                                                                             0.1s
 => => sha256:765942a4039992336de8dd5db680586e1a206607dd06170ff0a37267a9e01958 9.22kB / 9.22kB                                                                        0.0s
 => => sha256:008827ed2172a676b08121e21cf9db0ce08a90ee6c8a12fc374af8a56c0e496d 1.02kB / 1.02kB                                                                        0.0s
 => => sha256:e89557652e7472b26d49f1d45638ac744a2928ddada818777a6ce4076f64f7e6 581B / 581B                                                                            0.0s
 => => sha256:5311e7f182d02360a7194aa2995849bcdf04795c39a0ffdcf413eae625865970 3.63MB / 3.63MB                                                                        0.0s
 => CANCELED [2/6] RUN apk --no-cache add     bash bash-completion     ca-certificates tzdata     curl coreutils     busybox-extras     diffutils file findutils   2265.8s
ERROR: failed to solve: Canceled: context canceled                                                                                                                         
^C
admin@docker-host ✖ docker build -t abc .
[+] Building 40.5s (10/10) FINISHED                                                                                                                         docker:default
 => [internal] load build definition from Dockerfile                                                                                                                  0.0s
 => => transferring dockerfile: 2.29kB                                                                                                                                0.0s
 => [internal] load metadata for docker.io/library/alpine:3.20                                                                                                       30.2s
 => [internal] load .dockerignore                                                                                                                                     0.0s
 => => transferring context: 2B                                                                                                                                       0.0s
 => CACHED [1/6] FROM docker.io/library/alpine:3.20@sha256:765942a4039992336de8dd5db680586e1a206607dd06170ff0a37267a9e01958                                           0.0s
 => [2/6] RUN apk --no-cache add     bash bash-completion     ca-certificates tzdata     curl coreutils     busybox-extras     diffutils file findutils     gnupg gr  6.9s
 => [3/6] RUN curl -fsSL -o /usr/local/bin/yq       "https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64"     && chmod +x /usr/local/bin/yq      0.8s 
 => [4/6] RUN addgroup -g 1000 ibtisam     && adduser -D -u 1000 -G ibtisam -s /bin/bash ibtisam                                                                      0.4s 
 => [5/6] WORKDIR /home/ibtisam                                                                                                                                       0.0s 
 => [6/6] RUN echo "alias ll='ls -alF'" >> ~/.bashrc &&     echo "alias json='jq .'" >> ~/.bashrc &&     echo 'alias yaml="yq ."' >> ~/.bashrc &&     echo "export P  0.5s 
 => exporting to image                                                                                                                                                1.6s 
 => => exporting layers                                                                                                                                               1.6s 
 => => writing image sha256:8be90a7af10c72a494e064dae1999b732d38bfda6428d01871d8e2492faf41d0                                                                          0.0s
 => => naming to docker.io/library/abc                                                                                                                                0.0s

admin@docker-host ➜  
```


