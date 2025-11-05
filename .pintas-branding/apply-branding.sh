#!/bin/bash
# Script per applicare il branding Pintas Assistenza
# Esegui questo dopo ogni merge con upstream
# GitHub Actions eseguirà questo automaticamente

set -e

echo "🎨 Applicando branding Pintas Assistenza..."

# 1. Modifica Cargo.toml
echo "📦 Aggiornamento Cargo.toml..."
sed -i.bak 's/name = "rustdesk"/name = "pintas-assistenza"/' Cargo.toml
sed -i.bak 's/RustDesk/Pintas Assistenza/g' Cargo.toml

# 2. Modifica src/common.rs
if [ -f "src/common.rs" ]; then
    echo "🔧 Aggiornamento src/common.rs..."
    sed -i.bak 's/pub const APP_NAME: &str = "RustDesk"/pub const APP_NAME: \&str = "Pintas Assistenza"/' src/common.rs
    sed -i.bak 's/hbb.com/pintas.com/g' src/common.rs
fi

# 3. Modifica file di configurazione Flutter
if [ -f "flutter/pubspec.yaml" ]; then
    echo "📱 Aggiornamento Flutter config..."
    sed -i.bak 's/name: rustdesk/name: pintas_assistenza/' flutter/pubspec.yaml
    sed -i.bak 's/description: RustDesk/description: Pintas Assistenza/' flutter/pubspec.yaml
fi

# 4. Modifica Info.plist per macOS
if [ -f "flutter/macos/Runner/Info.plist" ]; then
    echo "🍎 Aggiornamento Info.plist macOS..."
    sed -i.bak 's/RustDesk/Pintas Assistenza/g' flutter/macos/Runner/Info.plist
    sed -i.bak 's/com.carriez.rustdesk/com.pintas.assistenza/g' flutter/macos/Runner/Info.plist
fi

# 5. Modifica AndroidManifest.xml
if [ -f "flutter/android/app/src/main/AndroidManifest.xml" ]; then
    echo "🤖 Aggiornamento AndroidManifest..."
    sed -i.bak 's/com.carriez.flutter_hbb/com.pintas.assistenza/' flutter/android/app/src/main/AndroidManifest.xml
fi

# 6. Copia le icone personalizzate
echo "🖼️  Copiando icone personalizzate..."
if [ -d ".pintas-branding/icons" ]; then
    cp -f .pintas-branding/icons/icon.ico res/
    cp -f .pintas-branding/icons/icon.icns res/
    cp -f .pintas-branding/icons/icon.png res/
    
    # Flutter icons
    if [ -d "flutter/assets" ]; then
        cp -f .pintas-branding/icons/* flutter/assets/
    fi
fi

# 7. Aggiorna stringhe UI in italiano
if [ -f "src/lang/it.rs" ]; then
    echo "🇮🇹 Aggiornamento traduzioni italiane..."
    sed -i.bak 's/RustDesk/Pintas Assistenza/g' src/lang/it.rs
fi

# 8. Configura URL server personalizzato (se necessario)
if [ -n "$PINTAS_SERVER_URL" ]; then
    echo "🌐 Configurazione server personalizzato: $PINTAS_SERVER_URL"
    # Aggiungi la configurazione del server qui
fi

# 9. Aggiorna URL aggiornamenti
echo "🔄 Configurazione URL aggiornamenti..."
if [ -f "src/ui_interface.rs" ]; then
    sed -i.bak "s|https://github.com/rustdesk/rustdesk|https://github.com/$GITHUB_REPOSITORY|g" src/ui_interface.rs
fi

# 10. Pulisci file backup
echo "🧹 Pulizia file temporanei..."
find . -name "*.bak" -delete

echo "✅ Branding Pintas Assistenza applicato con successo!"
echo ""
echo "📋 Modifiche applicate:"
echo "   - Nome applicazione: Pintas Assistenza"
echo "   - Package name: pintas-assistenza"
echo "   - Bundle ID: com.pintas.assistenza"
echo "   - Icone personalizzate"
echo "   - Traduzioni aggiornate"
echo ""
echo "⚠️  Ricordati di testare la compilazione prima di committare!"
