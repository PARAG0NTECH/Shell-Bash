#!/bin/bash

# Verificar se o Java está instalado
java -version

if [ $? -eq 0 ]; then
    echo "Java instalado"
else
    echo "Java não instalado"
    echo "Gostaria de instalar o Java? [s/n]"
    read get

    if [ "$get" == "s" ]; then
        # Instalar o Java 11
        sudo apt-get update
        sudo apt-get install openjdk-11-jdk -y
    else
        echo "O Java não foi instalado."
        exit 1  # Saia do script com código de erro
    fi
fi

Docker --version

if [ $? -eq 0 ]; then
    echo "Docker instalado"
else
    echo "Docker não instalado"
    echo "Gostaria de instalar o Docker? [s/n]"
    read get

    if [ "$get" == "s" ]; then
        # Instalar o Docker 
        
        sudo apt install Docker.io -y
        sudo systemctl start docker
        sudo systemctl enable docker
    else
        echo "O Docker não foi instalado."
        exit 1  # Saia do script com código de erro
    fi
fi

    #criando um container Docker


    sudo docker pull mysql:5.7
    sudo docker images

    # criando o container de MySQL
    sudo docker run -d -p 3306:3306 --name ContainerBD -e "MYSQL_DATABASE=banco1" -e "MYSQL_ROOT_PASSWORD=urubu100" mysql:5.7

    # Confirmando se foir criado
    sudo docker ps -a

     #Monitorando o consumo de recurso
     sudo docker stats ContainerBD

     #Para terminar o monitoramento, pressione “ctrl + c”

     


    # Baixar o arquivo cineproject.jar usando curl
    curl -o cineproject.jar -LJO https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/cineproject.jar

    # Verificar o status de saída do curl
    if [ $? -eq 0 ]; then
    java -jar cineproject.jar
    else
    echo "O curl encontrou um erro."
    fi
