# Setup GPG for first time use in container
set -e

echo "🔑 Configurando GPG para primeira utilização..."

# Ensure proper TTY
export GPG_TTY=$(tty)
echo "TTY atual: $GPG_TTY"

# Kill any existing gpg-agent
pkill gpg-agent 2>/dev/null || true

# Start fresh gpg-agent
eval "$(gpg-agent --daemon --allow-preset-passphrase)"

# Test GPG signing
echo "📝 Testando assinatura GPG..."
echo "test message" | gpg --clearsign

echo "✅ GPG configurado com sucesso!"
echo "💡 Sua senha ficará em cache" 
