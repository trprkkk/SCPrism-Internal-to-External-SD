#!/system/bin/sh

# ログファイル
logfile="/data/local/tmp/redirect_sc.log"
echo "Redirect module started" > "$logfile"

# SDカード候補を探す
for path in /storage/*; do
    name=$(basename "$path")
    if [ "$name" != "emulated" ] && [ "$name" != "self" ]; then
        SD_PATH="$path"
        break
    fi
done

echo "Detected SD path: $SD_PATH" >> "$logfile"

# SDカードのアプリデータパス
SRC="$SD_PATH/Android/data/com.bandainamcoent.shinycolorsprism"
DST="/storage/emulated/0/Android/data/com.bandainamcoent.shinycolorsprism"

echo "SRC: $SRC" >> "$logfile"
echo "DST: $DST" >> "$logfile"

# SDカードがマウントされるまで最大10秒待つ
for i in $(seq 1 10); do
    if [ -d "$SD_PATH/Android/data" ]; then
        break
    fi
    sleep 1
done

# SRCが存在しなければ作成
if [ ! -d "$SRC" ]; then
    echo "Source directory not found, creating empty folder: $SRC" >> "$logfile"
    mkdir -p "$SRC"
fi

# バインドマウント
mkdir -p "$DST"
mount -o bind "$SRC" "$DST"
echo "Mounted $SRC to $DST" >> "$logfile"
