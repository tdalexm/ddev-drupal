#!/bin/bash
set -e

# Función para mostrar mensajes con color
msg() {
    echo -e "\e[1;34m$1\e[0m"
}

# Función para manejar errores
error() {
    echo -e "\e[1;31m❌ Error: $1\e[0m"
    exit 1
}


# Función para cambiar credenciales MySQL
# change_mysql_credentials() {
#    local old_user=root
#    local old_pass=root
#    local new_user=$1
#    local new_pass=$2
#   
#   msg "🔑 Actualizando credenciales MySQL..."
#   
#   ddev mysql -u${old_user} -p${old_pass} -e \
#       "CREATE USER '${new_user}'@'%' IDENTIFIED BY '${new_pass}';
#        GRANT ALL PRIVILEGES ON *.* TO '${new_user}'@'%';" || error "Falló el cambio de credenciales"
# }

# 1. Solicitar datos esenciales
msg "🚀 Configurador DDEV/Drupal para WSL"
read -p "🔵 PROJECT_NAME (ej: tdeveloper): " PROJECT_NAME
read -p "🔵 TLD (ej: 'es'| 'tdalex.es' | 'dewenir.es'): " TLD

[[ -z "$PROJECT_NAME" || -z "$TLD" ]] && error "PROJECT_NAME y TLD son obligatorios"

SITE_URL="${PROJECT_NAME}.${TLD}"
PROJECT_ROOT="/var/www/${SITE_URL}"


# 2. Configurar proyecto
msg "📂 Creando proyecto en $PROJECT_ROOT..."
sudo mkdir -p "${PROJECT_ROOT}" && sudo chown -R $USER:$USER "/var/www"
cd "${PROJECT_ROOT}"

sudo mkdir -p .ddev && sudo chown -R $USER:$USER ".ddev"
cat > .ddev/config.yaml <<EOL
name: ${PROJECT_NAME}
type: drupal11
docroot: web
php_version: "8.3"
webserver_type: nginx-fpm
database:
  type: mysql
  version: "8.0"
additional_fqdns:
  - ${SITE_URL}
project_tld: ${TLD}
use_dns_when_possible: false
EOL

# 3. Iniciar entorno DDEV
msg "🔌 Iniciando servicios DDEV..."
ddev start || error "Falló al iniciar DDEV"

# 4. Configurar Drupal
msg "🌍 Instalando Drupal 11..."
ddev composer create -y "drupal/recommended-project:^11"
ddev composer require drush/drush

DRUPAL_USER="tdeveloper"
DRUPAL_PASS="tDEVeloper2024!"
read -p "🔵 Usuario admin Drupal [$DRUPAL_USER]: " input_user
DRUPAL_USER=${input_user:-$DRUPAL_USER}
read -p "🔵 Contraseña admin [$DRUPAL_PASS]: " input_pass
DRUPAL_PASS=${input_pass:-$DRUPAL_PASS}


# 5. Instalar drupal
msg "⚙️ Instalando sitio Drupal..."
ddev drush si -y \
    --site-name="${PROJECT_NAME}" \
    --account-name="${DRUPAL_USER}" \
    --account-pass="${DRUPAL_PASS}" \
    --locale=es

# 6. Configurar SSL
msg "🔐 Configurando SSL..."
if ! command -v mkcert &>/dev/null; then
    curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
    chmod +x mkcert-v*-linux-amd64
    sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert
fi
mkcert -install

msg "🔄 Reiniciando entorno..."
ddev restart

# 7. Finalización
msg "✅ Instalación completada!"
echo "============================================"
echo "🌐 URL: https://${SITE_URL}"
echo "🔑 Drupal: ${DRUPAL_USER} / ${DRUPAL_PASS}"
echo "🐬 MySQL: root / root"
echo "🗄️ BBDD: db / db"
echo "📂 Directorio: ${PROJECT_ROOT}"
echo "--------------------------------------------"
echo "💻 Comandos:"
echo "   ddev composer install           # Instalación de dependencias"
echo "   ddev composer require <paquete> # Instalación de un paquete"
echo ""
echo "   ddev poweroff                   # Apaga todos los contendores"
echo "   ddev import-db <file>           # Importa una base de datos"
echo "   ddev export-db <file>           # Exporta la base de datos"
echo ""
echo "   ddev start/stop                 # Iniciar/parar proyecto"
echo "   ddev restart                    # Reiniciar proyecto"
echo "   ddev drush config:export        # Exportar configuraciones"
echo "   ddev drush config:import        # Importar configuraciones"
echo "============================================"
