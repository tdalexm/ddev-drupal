# DDEV

## [Instalar WSL](https://learn.microsoft.com/en-us/windows/wsl/basic-commands)

WSL(Windows Subsystem for Linux) te permite correr Linux en Windows. **Instalar a través de la powershell de Windows y cambiar a la versión 2** (Mejoras en el rendimiento de las maquinas).
> [!IMPORTANT] Puede que WSL no funcione despues de su inmediata instalación, en ese caso reiniciar.

```powershell
wsl --install
wsl --set-default-version 2
```

**Listar las distribuciones** que se pueden instalar:

```powershell
wsl --list --online
```

**Instalar una distribución**:

```powershell
wsl --install -d <distribution-name>
```

**Listar las distribuciones instaladas**:

```powershell
wsl --list
```
El resultado de este comando también muestra la **distribución por defecto** del sistema `Ubuntu (predeterminado)`

Apagar WSL:

```powershell
wsl --shutdown
```


## Ejecutar WSL

**Ejecutar** la distribución por defecto.

```powershell
wsl
```

**Ejecutar una distribución especifica**.

```powershell
wsl --distribution Ubuntu-24.04
```

En la instalación de WSL puede que se **instale una distribución de ubuntu y se asigne como por defecto**.

**Modificar la distribución por defecto** para que se ejecute con el siguiente comando:

```powershell
wsl --set-default Ubuntu-24.04
```

Es recomendable **eliminar la distribución** que se instala por defecto con el comando:

```powershell
wsl --unregister Ubuntu-24.04
```
## Instalaciones

### 1. Chocolatey

Chocolatey es un administrador de paquetes para Windows. Necesario para instalaciones posteriores.

Para instalar Chocolatey:

- Abrir **Powershell** como administrador
- Ejecutar el siguiente comando:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex
```

### 2. Instalar DDEV y DOCKER en Windows

Para poder correr DDEV en WSL hay que instalarlo en local e instalar docker.

- Abrir **powershell** como administrador.
- Ejecutar el siguiente comando:

```powershell
chocolatey install ddev docker-desktop
```

> [!IMPORTANT]: Es necesario reiniciar el ordenador después de instalarlo.

### 3. Instalar DOCKER y DDEV en WSL

Ejecutar el bash `install-ddev.sh` que se encuentra en este repositorio.

> [!IMPORTANT]: Es necesario reiniciar WSL despues de instalar docker.

Cuando se reinicie WSL es necesario volver a lanzar a lanzar el script para configurar los permisos de docker en WSL.

### 4. Instalación de drupal

Para instalar y montar el entorno Drupal es necesario ejecutar el archivo `setup-drupal.sh` y seguir las instrucciones.

## [DDEV](https://ddev.com/)

```shell
🌐 URL: https://${SITE_URL}"
🔑 Drupal: ${DRUPAL_USER} / ${DRUPAL_PASS}"
🐬 MySQL: root / root"
🗄️ BBDD: db / db"
📂 Directorio: ${PROJECT_ROOT}
----------------------------------------------------------------
💻 Comandos:
    ddev composer install           # Instalación de dependencias
    ddev composer require <paquete> # Instalación de un paquete
    ddev poweroff                   # Apaga todos los contendores

    ddev import-db <file>           # Importa una base de datos
    ddev export-db <file>           # Exporta la base de datos

    ddev start/stop                 # Iniciar/parar proyecto   
    ddeb restart                    # Reiniciar proyecto
    ddev drush config:export        # Exportar configuraciones
    ddev drush config:import        # Importar configuraciones
```
