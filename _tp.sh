#!/bin/sh
### Handles downloading and "installing" third party data

WINE_URI="https://github.com/Kron4ek/Wine-Builds/releases/download/11.15/wine-11.15-amd64-wow64.tar.xz"
DSOAL_URI="https://github.com/kcat/dsoal/releases/download/archive/DSOAL_r694.zip"
GAME_URI="https://github.com/Joshhhuaaa/EnhancedSCCTVersus/releases/download/v3.6/Enhanced-SCCT-Versus-v3.6.7z"
DXVK_URI="https://github.com/doitsujin/dxvk/releases/download/v3.0.2/dxvk-3.0.2.tar.gz"

HERE="$(cd "$(dirname "$0")" && pwd -P)"
APP_DIR="${HERE}/EnhancedSCCTVersus.AppDir"
WINE_DIR="${APP_DIR}/opt/wine/"
GAME_DIR="${APP_DIR}/opt/game/"
GAMESYS_DIR="${GAME_DIR}/System"


## # Start

mkdir _tmp
cd _tmp

## # Wine

mkdir wine
cd wine

echo "Downloading wine..."
wget "${WINE_URI}" -q --show-progress

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
wget "${GAME_URI}" -q --show-progress

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
wget "${DSOAL_URI}" -q --show-progress
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
wget "${DXVK_URI}" -q --show-progress

for f in *.gz; do file="$f"; break; done

echo "Extracting DXVK..."
tar -xzf "${file}" 

expected="d3d9.dll"
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
cp -r "${root_dir}/d3d9.dll" "${GAMESYS_DIR}"

# done
cd ../

## # Finish up

cd ../
echo "Cleaning up..."
rm -r _tmp
echo "Finished installing third party data!"
