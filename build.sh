#!/bin/bash
set -e

git add .
git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')" || echo "Tidak ada perubahan baru"
git push -u origin main

echo "Menunggu GitHub Actions memulai antrean..."
sleep 8

RUN_ID=$(gh run list --limit 1 --json databaseId -q '.[0].databaseId')
echo "Memantau Build ID: $RUN_ID"
gh run watch "$RUN_ID" --exit-status

echo "Mengunduh APK ke /sdcard/Download/..."
mkdir -p /sdcard/Download
rm -f /sdcard/Download/app-debug.apk
gh run download "$RUN_ID" -n app-debug -D /sdcard/Download/

echo "SELESAI! APK terbaru tersimpan di: /sdcard/Download/app-debug.apk"
