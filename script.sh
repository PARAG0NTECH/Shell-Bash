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

# Baixar o arquivo cineproject.jar usando curl
curl -o cineproject.jar -LJO https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/cineproject.jar

# Verificar o status de saída do curl
if [ $? -eq 0 ]; then
    java -jar cineproject.jar
else
    echo "O curl encontrou um erro."
fi
