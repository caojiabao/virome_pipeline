1.更新
sudo apt update

2. 安装一些必备软件包
sudo apt install apt-transport-https ca-certificates curl software-properties-common

3. 然后将官方 Docker 版本库的 GPG 密钥添加到系统中：
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

4. 将 Docker 版本库添加到APT源：
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

5. 接下来，我们用新添加的 Docker 软件包来进行升级更新
sudo apt update

6. 确保要从 Docker 版本库，而不是默认的 Ubuntu 版本库进行安装
apt-cache policy docker-ce

7. 最后，安装 Docker ：
sudo apt install docker-ce

8. 现在 Docker 已经安装完毕。我们启动守护程序。检查 Docker 是否正在运行：
sudo systemctl status docker


第 2 步—在不使用 sudo 的情况下执行 Docker 命令
如果不想用 sudo 来执行 docker 命令，那么我们只需要把对应的用户添加到 docker 组中即可。
sudo usermod -aG docker ${USER}

使用新组成员身份执行命令，需要注销后重新登录，或使用su来切换身份。
su - ${USER}


#singularity
apt-get update &&  apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev

apt install wget 
export VERSION=1.11 OS=linux ARCH=amd64
cd /tmp
wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.11.1.linux-amd64.tar.gz
echo 'export GOPATH=${HOME}/go' >> ~/.bashrc
echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc
source ~/.bashrc

mkdir -p $GOPATH/src/github.com/sylabs
cd $GOPATH/src/github.com/sylabs
apt install git 
git clone https://github.com/sylabs/singularity.git
cd singularity

go get -u -v github.com/golang/dep/cmd/dep
cd $GOPATH/src/github.com/sylabs/singularity
./mconfig
make -C builddir
make -C builddir install
singularity help


### 下面的镜像来自https://www.singularity-hub.org/collections/1625:
singularity pull --name CRISPRCasFinder shub://bneron/CRISPRCasFinder:latest 
singularity pull --name CRISPRCasFinder shub://bneron/CRISPRCasFinder:4.2.18 
./CRISPRCasFinder -def General -cas -i my_sequence.fasta -keep




#CRISPRcasFinder
/usr/bin/perl /software/software/CRISPRCasFinder-release-4.2.20/CRISPRCasFinder.pl \
contigs.fasta -soFile /software/software/CRISPRCasFinder-release-4.2.20/sel392v2.so -cas -def G -keep
