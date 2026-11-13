#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "=== 1. Aktualizacja systemu i instalacja bazowych pakietów ==="
yes | pkg update
yes | pkg upgrade
pkg install -y git gh python nodejs-lts tur-repo nano curl wget

echo "=== 2. Instalacja code-server (VS Code w przeglądarce) ==="
pkg install -y code-server

echo "=== 3. Instalacja Gemini CLI (Twój agent AI w terminalu) ==="
npm install -g @google/gemini-cli

echo "=== 4. Tworzenie struktury projektu i szablonu GitHub Actions ==="
mkdir -p ~/projekty/moj-projekt/.github/workflows
cd ~/projekty/moj-projekt

git init -b main

cat << 'YAML' > .github/workflows/build.yml
name: Automatyczne Budowanie i Testy

on:
  push:
    branches: [ "main" ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Pobranie kodu z repozytorium
        uses: actions/checkout@v4

      - name: Konfiguracja środowiska Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Uruchomienie testu / skryptu
        run: |
          echo "Środowisko GitHub Actions działa poprawnie!"
          python3 main.py
YAML

cat << 'PY' > main.py
def main():
    print("Projekt zainicjowany! Gotowy do budowania z Gemini CLI i GitHub Actions.")

if __name__ == "__main__":
    main()
PY

echo ""
echo "========================================================"
echo "GOTOWE! Środowisko zostało zainstalowane."
echo "Folder projektu: ~/projekty/moj-projekt"
echo "========================================================"
