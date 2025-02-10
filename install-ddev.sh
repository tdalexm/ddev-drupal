
# Función para mostrar mensajes con color
msg() {
    echo -e "\e[1;34m$1\e[0m"
}

# Función para manejar errores
error() {
    echo -e "\e[1;31m❌ Error: $1\e[0m"
    exit 1
}

# Función para configurar Docker
setup_docker() {
    if ! docker info >/dev/null 2>&1; then
        msg "🔧 Configurando Docker..."
        
        sudo groupadd docker 2>/dev/null || true
        sudo usermod -aG docker $USER
        sudo chmod 660 /var/run/docker.sock
        sudo chown root:docker /var/run/docker.sock
        
        error "Reinicia WSL con: wsl --shutdown y vuelve a ejecutar el script"
    fi
}

# 1. Instalar dependencias
msg "📦 Instalando dependencias del sistema..."
sudo apt update -qq && sudo apt upgrade -y -qq
sudo apt install -qq -y \
    curl git libnss3-tools \
    software-properties-common \
    apt-transport-https \
    ca-certificates gnupg-agent


# 2. Instalar DDEV
if ! command -v ddev &> /dev/null; then
    echo "🚀 Instalando DDEV..."
    # Add DDEV’s GPG key to your keyring
    sudo sh -c 'echo ""'
    sudo apt-get update && sudo apt-get install -y curl
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://pkg.ddev.com/apt/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/ddev.gpg > /dev/null
    sudo chmod a+r /etc/apt/keyrings/ddev.gpg

    # Add DDEV releases to your package repository
    sudo sh -c 'echo ""'
    echo "deb [signed-by=/etc/apt/keyrings/ddev.gpg] https://pkg.ddev.com/apt/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list >/dev/null
fi

# 3. Instalar Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -qq
    sudo apt install -qq -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
else 
	msg "🐳 Docker ya instalado."
fi

# 3.1 Configurar Docker
echo "🐳 Configurando Docker..."
setup_docker

# Verificar Docker después de configuración
if ! docker info >/dev/null 2>&1; then
    echo "❌ Error: No se pudo configurar Docker correctamente"
    echo "Por favor:"
    echo "1. Asegúrate de tener Docker Desktop instalado y corriendo"
	echo "2. Reinicia WSL con: wsl --shutdown"
    echo "3. En Docker Desktop Settings > Resources > WSL Integration:"
    echo "   - Habilita tu distro WSL"
    exit 1
fi
