# local/remote-util:3
From  gogost/gost:latest
ENV PATH="/root/.krew/bin:$PATH"
ENV VERIFY_CHECKSUM=false
RUN apk add
RUN apk add iputils bind-tools netcat-openbsd iproute2 net-tools curl wget   tcpdump procps-ng nmap lsof git
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN wget https://github.com/siderolabs/talos/releases/download/v1.12.0/talosctl-linux-amd64 && install -o root -g root -m 0755 talosctl-linux-amd64  /usr/local/bin/talosctl
RUN ( set -x; cd "$(mktemp -d)" && OS="$(uname | tr '[:upper:]' '[:lower:]')" && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && KREW="krew-${OS}_${ARCH}" && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && tar zxvf "${KREW}.tar.gz" && ./"${KREW}" install krew )
RUN export PATH="$HOME/.krew/bin:$PATH" && kubectl krew install oidc-login
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | sh
RUN wget https://github.com/siderolabs/omni/releases/download/v1.4.0/omnictl-linux-amd64  && install -o root -g root -m 0755 omnictl-linux-amd64  /usr/local/bin/omnictl
