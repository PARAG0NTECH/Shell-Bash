#!/bin/bash


LOG_FILE="installation_log.txt"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S"): $1" >> "$LOG_FILE"
}

exec &> "$LOG_FILE"
echo "$(date +"%Y-%m-%d %H:%M:%S"): $1" >> "$LOG_FILE"

log "Starting installation script..."

sudo apt-get update

if [ $? -eq 0 ]; then
    log "Updating package list successful"
    JAR_URLS=(
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/checker-qual-3.12.0.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/error_prone_annotations-2.11.0.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/failureaccess-1.0.1.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/guava-31.1-jre.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/j2objc-annotations-1.3.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/jna-5.10.0.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/jna-platform-5.10.0.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/jsr305-3.0.2.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/looca-api-2.2.0.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/mssql-jdbc-12.4.2.jre11.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/mysql-connector-j-8.1.0.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/oshi-core-6.1.5.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/protobuf-java-3.21.9.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/slf4j-api-1.7.30.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/slf4j-simple-1.7.30.jar"
        "https://github.com/PARAG0NTECH/JAR-PROJETO/raw/main/teste_cinecine_jar/teste-cinecine.jar"

    )
    for URL in "${JAR_URLS[@]}"; do
        curl -O -L "$URL"
        if [ $? -ne 0 ]; then
            log "Error downloading JAR file from $URL"
            exit 1
        fi
    done
    log "JAR files downloaded successfully"
else 
    log "Error updating package list"
fi
sleep 5

if [ $? -eq 0 ]; then

    docker --version

    if [ $? -eq 0 ]; then
        echo "Docker instalado"
    else
        echo "Docker não instalado"
        echo "Gostaria de instalar o Docker? [s/n]"
        read get

        if [ "$get" == "s" ]; then
            # Instalar o Docker
            sudo apt-get install docker.io -y
            sudo systemctl start docker
            sudo systemctl enable docker
        else
            echo "O Docker não foi instalado."
            exit 1  # Saia do script com código de erro
        fi
    fi

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
            sudo apt-get-get update
            sudo apt-get-get install openjdk-17-jdk -y
        else
            echo "O Java não foi instalado."
            exit 1  # Saia do script com código de erro
        fi
    fi
    
    cd ../..
    cd var/run
    
    sudo mkdir mysqld 
    sudo touch mysqld.sock

    if [ $? -eq 0 ]; then
        sudo docker run -d --name mysql-container -e MYSQL_ROOT_PASSWORD=my-secret -e MYSQL_DATABASE=cineguardian -p 3306:3306 mysql:8
        sleep 10
        sudo docker exec -i mysql-container mysql -uroot -pmy-secret cineguardian < setup-script.sql
    fi
    if [ $? -eq 0 ]; then
        sleep 10   
        java -jar teste-cinecine.jar SETUP
    fi
else
    echo "Erro nos curls"
fi
