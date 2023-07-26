FROM node:alpine

# Instala OpenJDK 12 y el SDK de Android
RUN apk add --no-cache openjdk12
RUN mkdir -p /opt/android-sdk/cmdline-tools
ADD https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip /opt/android-sdk/cmdline-tools/sdk-tools.zip
RUN unzip /opt/android-sdk/cmdline-tools/sdk-tools.zip -d /opt/android-sdk/cmdline-tools
RUN mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

# Establece las variables de entorno necesarias para el SDK de Android
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

# Acepta las licencias del SDK de Android
RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses


# Instala las dependencias necesarias para compilar proyectos de React Native
RUN apk add --no-cache bash build-base
RUN apt-get update && apt-get install -y \ apt-utils 
RUN apt-get update && apt-get install -y git

WORKDIR /app

# Copia los archivos de package.json y package-lock.json (o yarn.lock si utilizas yarn)
COPY package*.json ./

#Elimina el directorio vendor de sharp para evitar errores de compilación
RUN rm -rf node_modules/sharp/vendor

#instalar el modulo mde sharp
#RUN npm install sharp 

# Instala las dependencias necesarias
#RUN npm install

# Copia el resto del proyecto al contenedor
COPY AppContinentalV3-master/ .

# Instala react-native en el proyecto (Opcional, solo si aún lo necesitas)
 # RUN npm install -g react-native@0.60.4

# Instala bash en el contenedor (esto puede solucionar el error)
RUN apk add --no-cache bash

# Desvincula las dependencias manualmente
#RUN  react-native unlink react-native-geolocation-service
#RUN  react-native unlink react-native-svg

# Limpia el proyecto de Android
#RUN cd android && ./gradlew clean
#RUN react-native start --reset-cache
# Reconstruye el proyecto (ejecuta el comando run-android)
#RUN npx react-native run-android --no-jetifier

# Expone el puerto 8081 para el desarrollo de React
EXPOSE 8081

# Inicia la aplicación de React
 CMD ["npm", "start"]