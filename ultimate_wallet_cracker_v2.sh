#!/bin/bash

echo "=============================="
echo "🔥 Ultimate Wallet Cracker v2 🔥"
echo "=============================="

# === Ask for Telegram integration ===
read -p "🔐 Enter Telegram Bot Token: " TG_TOKEN
read -p "📬 Enter Telegram Chat ID: " TG_CHAT_ID

# === Function to send message to Telegram ===
send_telegram() {
    local MSG="$1"
    curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
        -d chat_id="${TG_CHAT_ID}" -d text="$MSG" > /dev/null
}

# === Ask for hash file ===
read -p "📁 Enter path to hash file (e.g., wallet.hash): " HASH_FILE
read -p "🔢 Enter hash mode (e.g., 11300 for Bitcoin Core): " HASH_MODE

# === Choose attack type ===
echo "Choose attack type:"
echo "1) mask"
echo "2) wordlist"
echo "3) wordlist+rules"
echo "4) combinator"
echo "5) pure-brute"
echo "6) ai-smart"
echo "7) dictionary-combo"
echo "8) hybrid"
echo "9) custom"

read -p "Enter choice [1-9]: " CHOICE

CMD=""

case $CHOICE in
  1)
    read -p "Enter mask (e.g., ?l?l?l?l?l?d?d): " MASK
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 3 $MASK"
    ;;
  2)
    read -p "Enter wordlist path: " WL
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 0 $WL"
    ;;
  3)
    read -p "Enter wordlist path: " WL
    read -p "Enter rule path: " RULE
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 0 $WL -r $RULE"
    ;;
  4)
    read -p "Enter first wordlist: " WL1
    read -p "Enter second wordlist: " WL2
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 1 $WL1 $WL2"
    ;;
  5)
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 3 ?a?a?a?a?a?a?a?a"
    ;;
  6)
    echo "[*] Generating AI-style smart wordlist..."
    echo "SuperSecurePassword" > ai_wordlist.txt
    echo "P@ssw0rd1984" >> ai_wordlist.txt
    echo "CryptoKing!" >> ai_wordlist.txt
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 0 ai_wordlist.txt"
    ;;
  7)
    read -p "Enter dictionary: " DICT
    read -p "Enter combo list: " COMBO
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 6 $DICT $COMBO"
    ;;
  8)
    read -p "Enter dictionary: " DICT
    read -p "Enter mask (e.g., ?d?d): " MASK
    CMD="hashcat -m $HASH_MODE $HASH_FILE -a 6 $DICT $MASK"
    ;;
  9)
    read -p "Enter custom full Hashcat command: " CMD
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

echo "[*] Running command:"
echo "$CMD"
sleep 1

# === Run the command ===
$CMD

# === FINAL CHECK ===
if grep -q ":" hashcat.potfile; then
  CRACKED=$(cat hashcat.potfile)
  echo "✅ Cracked: $CRACKED"
  send_telegram "✅ Cracked: $CRACKED"
else
  echo "❌ Cracking session ended. Password not found."
  send_telegram "❌ Cracking session ended. Password not found."
fi
