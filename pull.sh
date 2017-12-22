#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

KUBE_VERSION=v1.7.5
KUBE_PAUSE_VERSION=3.0
ETCD_VERSION=3.0.17
DNS_VERSION=1.14.4

GCR_URL=gcr.io/google_containers
RALPHJIN_URL=ralphjin


images=(kube-proxy-amd64:${KUBE_VERSION}
kube-scheduler-amd64:${KUBE_VERSION}
kube-controller-manager-amd64:${KUBE_VERSION}
kube-apiserver-amd64:${KUBE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
etcd-amd64:${ETCD_VERSION}
k8s-dns-sidecar-amd64:${DNS_VERSION}
k8s-dns-kube-dns-amd64:${DNS_VERSION}
k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION})


for imageName in ${images[@]} ; do
  name=`echo $imageName|awk -F ":" '{print $1}'`
  echo $name
  docker pull $RALPHJIN_URL/$name
  docker tag  $RALPHJIN_URL/$name $GCR_URL/$imageName 
  docker pull $RALPHJIN_URL/$name
done
# remove --pull from below files:
#    build/debian-iptables/Makefile
#    build/debian-base/Makefile
#    build/debian-hyperkube-base/Makefile
#    build/pause/Makefile
#    build/lib/release.sh
#    build/build-image/cross/Makefile
#    /root/kubernetes/cluster/images/hyperkube/Makefile
#    /root/kubernetes/cluster/images

# what they look like before removing --pull
#build-image/cross/Makefile:	docker build --pull -t k8s.gcr.io/$(IMAGE):$(TAG) .
#common.sh:# $3 is the value to set the --pull flag for docker build; true by default
#common.sh:  local -ra build_cmd=("${DOCKER[@]}" build -t "${image}" "--pull=${pull}" "${context_dir}")
#debian-base/Makefile:	docker build --pull -t $(BUILD_IMAGE) -f $(TEMP_DIR)/Dockerfile.build $(TEMP_DIR)
#debian-hyperkube-base/Makefile:	docker build --pull -t $(REGISTRY)/$(IMAGE)-$(ARCH):$(TAG) $(TEMP_DIR)
#lib/release.sh:        "${DOCKER[@]}" build --pull -q -t "${docker_image_tag}" ${docker_build_path} >/dev/null
#pause/Makefile:	docker build --pull -t $(IMAGE):$(TAG) --build-arg ARCH=$(ARCH) .
#[root@virt-v2v images]# grep -r pull *
#etcd/Makefile:	docker build --pull -t $(REGISTRY)/etcd-$(ARCH):$(REGISTRY_TAG) $(TEMP_DIR)
#etcd-empty-dir-cleanup/Makefile:	docker build --pull -t $(IMAGE):$(TAG) .
#etcd-version-monitor/etcd-version-monitor.go:	// This will be replaced by https://github.com/coreos/etcd/pull/8960 in etcd 3.3.
#hyperkube/Makefile:	docker build --pull -t ${REGISTRY}/hyperkube-${ARCH}:${VERSION} ${TEMP_DIR}
#kubemark/Makefile:	docker build --pull -t $(REGISTRY)/$(PROJECT)/kubemark .
#[root@virt-v2v images]# pwd
#/root/kubernetes/cluster/images


