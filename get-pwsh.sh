#!/bin/sh

set -e 
set -x

PWSH_VERSION="${1:-7.4.6}"

if command -v curl > /dev/null 2>&1; then
    DOWNLOAD_CMD="curl -L -o"
    echo "Using curl for download..."
elif command -v wget > /dev/null 2>&1; then
    DOWNLOAD_CMD="wget -O"
    echo "Using wget for download..."
else
    echo "Neither curl nor wget is installed. Please install one of them."
    exit 1
fi

if ! command -v tar > /dev/null 2>&1; then
    echo "tar command is not installed. Please install tar."
    exit 1
fi

download_and_extract() {
    arch=$1
    url=$2
    dest_dir=$3
    tmp_file=$4

    echo "Downloading PowerShell version $PWSH_VERSION for $arch architecture..."

    $DOWNLOAD_CMD $tmp_file $url
    
    tar -xzf $tmp_file -C $dest_dir

    rm -f $tmp_file
}

url_amd64="https://github.com/PowerShell/PowerShell/releases/download/v$PWSH_VERSION/powershell-$PWSH_VERSION-linux-x64.tar.gz"
url_arm64="https://github.com/PowerShell/PowerShell/releases/download/v$PWSH_VERSION/powershell-$PWSH_VERSION-linux-arm64.tar.gz"
tmp_amd64="/tmp/powershell-amd64.tar.gz"
tmp_arm64="/tmp/powershell-arm64.tar.gz"

mkdir -p /powershell/7/arm64 /powershell/7/amd64

download_and_extract amd64 $url_amd64 /powershell/7/amd64 $tmp_amd64 &
pid_amd64=$!
download_and_extract arm64 $url_arm64 /powershell/7/arm64 $tmp_arm64 &
pid_arm64=$!

wait $pid_amd64 || { echo "Download and extraction for amd64 failed."; exit 1; }
wait $pid_arm64 || { echo "Download and extraction for arm64 failed."; exit 1; }

echo "Download and extraction of PowerShell version $PWSH_VERSION completed successfully."