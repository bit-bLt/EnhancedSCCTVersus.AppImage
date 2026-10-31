#!/bin/sh
### Handles downloading and "installing" third party data

WINE_URL="https://github.com/Kron4ek/Wine-Builds/releases/download/11.20/wine-11.20-amd64-wow64.tar.xz"
DSOAL_URL="https://github.com/kcat/dsoal/releases/download/latest-master/DSOAL.zip"
GAME_URL="https://drive.usercontent.google.com/download?export=download&id=1rI6-48Ntp7FsGW1BMwA2yZjDe10N5b2e&confirm=t"
DXVK_URL="https://github.com/doitsujin/dxvk/releases/download/v3.1.1/dxvk-3.1.1.tar.gz"

HERE="$(cd "$(dirname "$0")" && pwd -P)"
APP_DIR="${HERE}/EnhancedSCCTVersus.AppDir"
WINE_DIR="${APP_DIR}/opt/wine/"
GAME_DIR="${APP_DIR}/opt/game/"
GAMESYS_DIR="${GAME_DIR}/System"
CMD_CHECK="7z unzip tar wget"

## # Start

missing=0
for cmd in $CMD_CHECK; do
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "Missing command: ${cmd}"
        missing=1
    fi
done

if [ $missing -eq 1 ]; then
    echo "Please install missing commands and try again."
    exit 1
fi

mkdir _tmp
cd _tmp

## # Wine

mkdir wine
cd wine

echo "Downloading wine..."
wget "${WINE_URL}" -q --show-progress

for f in *.xz; do file="$f"; break; done

echo "Extracting wine..."
tar -xJf "${file}"

expected="bin include lib share"
expected_c=$(echo $expected | wc -w)
root_dir=""

echo "Locating data..."
# Switch to new line sep since file and dir names might have spaces
OLD_IFS=$IFS
IFS='
'
for d in $(find . -type d); do
    IFS=$OLD_IFS    
    found_c=0

    for sub in $expected; do
        [ -e "$d/$sub" ] && found_c=$((found_c + 1))     
    done

    if [ "$found_c" -eq "$expected_c" ]; then
        root_dir="$d"
        break;
    fi
done

if [ "${root_dir}" = "" ]; then
    echo "Error: Could not find root dir for Wine data"
    exit 1
fi

echo "Copying wine data..."
cp -r "${root_dir}/." "${WINE_DIR}"


# done
cd ../


## # GAME

mkdir game
cd game

echo "Downloading game..."

case "${GAME_URL}" in
    *"google"*)
        echo "Detected Google Drive Link..."
        wget --no-check-certificate -r -q --show-progress "${GAME_URL}" -O game.7z
    ;;
        *)
        wget "${GAME_URL}" -q --show-progress
    ;;
esac


for f in *.7z; do file="$f"; break; done

echo "Extracting game..."
7z x "${file}" -bso0 -bsp1

expected="System Packages Menus"
expected_c=$(echo $expected | wc -w)
root_dir=""


echo "Locating game data..."
# Switch to new line sep since file and dir names might have spaces
OLD_IFS=$IFS
IFS='
'
for d in $(find . -type d); do
    IFS=$OLD_IFS    
    found_c=0

    for sub in $expected; do
        [ -e "$d/$sub" ] && found_c=$((found_c + 1))      
    done

    if [ "$found_c" -eq "$expected_c" ]; then
        root_dir="$d"
        break
    fi
done

if [ "${root_dir}" = "" ]; then
    echo "Error: Could not find root dir for game data"
    exit 1
fi

echo "Copying game data..."
cp -r "${root_dir}/." "${GAME_DIR}"

# done
cd ../


## # DSOAL

mkdir dsoal
cd dsoal

echo "Downloading dsoal..."
wget "${DSOAL_URL}" -q --show-progress
for f in *.zip; do file="$f"; break; done

echo "Extracting dsoal..."
unzip -q -o "${file}" -d ./inner 

# dsoal often ships zip in zip
for f in ./inner/*.zip; do file="$f"; break; done
unzip -q -o "${file}"

expected="alsoft.ini dsoal-aldrv.dll dsound.dll"
expected_c=$(echo $expected | wc -w)
root_dir=""

echo "Locating dsoal data..."
# Switch to new line sep since file and dir names might have spaces
OLD_IFS=$IFS
IFS='
'

for d in $(find . -type d); do
    IFS=$OLD_IFS    
    found_c=0

    # We don't want 64bit libs 
    case "$d" in
        *64*)
            continue
            ;;
    esac

    for sub in $expected; do
        [ -e "$d/$sub" ] && found_c=$((found_c + 1))
    done

    if [ "$found_c" -eq "$expected_c" ]; then
        root_dir="$d"
        break
    fi
done

if [ "${root_dir}" = "" ]; then
    echo "Error: Could not find root dir for dsoal data"
    exit 1
fi

echo "Modifying alsoft.ini..."
sed -i 's/#boost = 0/boost = -6/' "${root_dir}/alsoft.ini"

echo "Copying dsoal data..."
cp -r "${root_dir}/." "${GAMESYS_DIR}"

# done
cd ../


## # DXVK

mkdir dxvk
cd dxvk

echo "Downloading DXVK..."
wget "${DXVK_URL}" -q --show-progress

for f in *.gz; do file="$f"; break; done

echo "Extracting DXVK..."
tar -xzf "${file}" 

expected="d3d11.dll"
expected_c=$(echo $expected | wc -w)
root_dir=""

echo "Locating DXVK data..."
# Switch to new line sep since file and dir names might have spaces
OLD_IFS=$IFS
IFS='
'
for d in $(find . -type d); do
    IFS=$OLD_IFS    
    found_c=0

    case "$d" in
        *64*)
            continue
            ;;
    esac

    for sub in $expected; do
        [ -e "$d/$sub" ] && found_c=$((found_c + 1))
    done

    if [ "$found_c" -eq "$expected_c" ]; then
        root_dir="$d"
        break
    fi
done

if [ "${root_dir}" = "" ]; then
    echo "Error: Could not find root dir for game data"
    exit 1
fi

echo "Copying DXVK data..."
cp -r "${root_dir}/d3d11.dll" "${GAMESYS_DIR}"
cp -r "${root_dir}/dxgi.dll" "${GAMESYS_DIR}"

# done
cd ../

## # Finish up

cd ../
echo "Cleaning up..."
rm -r _tmp
echo "Finished installing third party data!"
