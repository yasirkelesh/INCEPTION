#!/bin/bash



# Alan adı ve e-posta bilgisi (manuel olarak tanımlayın)
DOMAIN="mrkeles.duckdns.org" # Alan adını buraya yazın
EMAIL="mrkeles@mrkeles.duckdns.org" # E-posta adresini buraya yazın

# Certbot'un kurulu olup olmadığını kontrol edin
if ! command -v certbot &> /dev/null; then
    echo "Certbot yüklü değil. Şimdi kurulum yapılıyor..."
    sudo apt update
    sudo apt install certbot -y

    # Certbot kurulum kontrolü
    if ! command -v certbot &> /dev/null; then
        echo "Certbot yüklenemedi. Lütfen elle kontrol edin."
        exit 1
    fi
fi

echo "Certbot yüklü."


# Ana makinenin IP'sini bul
HOST_IP=$(ip route | grep default | awk '{print $3}')

# SSL sertifikası almak için certbot'u çalıştır
echo "Let's Encrypt üzerinden sertifika alınıyor..."
sudo certbot certonly --standalone -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email --preferred-challenges http --http-01-address $HOST_IP

# Sertifika oluşturma sonucu kontrol
if [ $? -eq 0 ]; then
    echo "Sertifika başarıyla oluşturuldu!"
    echo "SSL sertifikaları şu dizinde yer almaktadır:"
    echo "/etc/letsencrypt/live/$DOMAIN/"
else
    echo "Sertifika oluşturulamadı. Lütfen hata mesajlarını kontrol edin."
    exit 2
fi

# Sertifika yenileme bilgisi
echo "-----------------------------"
echo "Not: Sertifika 90 gün geçerlidir. Yenilemek için şu komutu çalıştırabilirsiniz:"
echo "sudo certbot renew"
