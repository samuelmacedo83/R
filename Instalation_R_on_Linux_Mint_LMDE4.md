# Como instalar (ou fazer o *update*) o R 4.0 on Linux Mint LMDE4



1. Abra o terminal com *ctrl + alt + t* 
2. Adicione a chave por meio do seguinte código

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E19F5F87128899B192B1A2C2AD5F960A256A04AF

```
3. Adicione o endereço do arquivo .deb no *source.list*

```
sudo echo "deb http://cloud.r-project.org/bin/linux/debian buster-cran40/" | sudo tee -a /etc/apt/sources.list
sudo apt update

```
4. Caso já tenha instalado o *r-base* e o *r-base-dev* é necessário removê-los

```
sudo apt purge r-base r-base-dev
sudo apt autoremove

```
5. Agora, após a remoção, pode-se fazer a instalação do novo *r-base* e do *r-base-dev*

```
sudo apt install r-base r-base-dev
sudo apt upgrade

```

### Instalar as dependências do sistema para trabalhar com o *devtools* e o *tidyverse* para trabalhar

```
sudo apt update
sudo apt install libcurl4-openssl-dev libxml2-dev libssl-dev
sudo apt install libgit2-dev libssh2-1-dev

```


Estas informações estão disponíveis [aqui](https://cran.r-project.org/bin/linux/debian/#general-information)