## Support

Supports EnhancedSCCTVersus 4.0+

## Build Process

### Auto External Data

Run: ./build.sh --auto

### Manual External Data

**Note:** See [AppDir Directory Structure](#appdir-directory-structure) for proper structure

1. Place game in opt/game/

2. Place wine in opt/wine/

3. Add 32bit dxvk (d3d9.dll) to game system folder

4. Add 32bit dsoal (dsound.dll, dsoal-aldrv.dll, alsoft.ini) to game system folder

5. Modify alsoft.ini as needed

6. Run ./build.sh

## Externals

### Enhanced SCCT Versus

https://github.com/Joshhhuaaa/EnhancedSCCTVersus/releases

### Wine

The following repository is recommended:
https://github.com/Kron4ek/Wine-Builds/releases

### DXVK

https://github.com/doitsujin/dxvk/releases

### DSOAL

https://github.com/kcat/dsoal/releases

## Game Data

Stored in: ~/local/share/EnhancedSCCTVersus/game

### Note on Game Data, Configuration, and Log Files

Specific files that require write access, such as config files and log files, will remain persistent and writeable within ~/.local/share/EnhancedSCCTVersus/game

The rest of the game data in that folder are temporary symbolic links created at runtime.


## AppDir Directory Structure

```
EnhancedSCCTVersus.AppDir
├── AppRun
├── EnhancedSCCTVersus.desktop
├── icon.png
└── opt
    ├── game
    │   ├── Menus
    │   ├── Packages
    │   └── System
    │       ├── alsoft.ini
    │       ├── d3d9.dll
    │       ├── dsoal-aldrv.dll
    │       └── dsound.dll
    └── wine
        ├── bin
        ├── include
        ├── lib
        └── share
```
