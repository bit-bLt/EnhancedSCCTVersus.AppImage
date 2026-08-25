## Support

Supports EnhancedSCCTVersus 4.0+

## Build Process

### Auto Third-Party

./build.sh --auto

### Manual Third-Party

**Note:** See [AppDir Directory Structure](#appdir-directory-structure) for proper structure

1. Place game in opt/game/

2. Place wine in opt/wine/

3. Add 32bit dxvk (d3d9.dll) to game system folder

4. Add 32bit dsoal (dsound.dll, dsoal-aldrv.dll, alsoft.ini) to game system folder

5. Modify alsoft.ini as needed

6. Ensure icon.png in root of EnhancedSCCTVersus.AppDir

7. Run ./build.sh

## Third-Party

### Enhanced SCCT Versus

https://github.com/Joshhhuaaa/EnhancedSCCTVersus/releases

### Wine

I recommend grabbing the vanilla, non-staging, wow64 wine build from the following repository:
https://github.com/Kron4ek/Wine-Builds/releases

### DXVK

https://github.com/doitsujin/dxvk/releases

### DSOAL

https://github.com/kcat/dsoal/releases

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
    │       ├── d3d9.dll
    │       ├── dsoal-aldrv.dll
    │       └── dsound.dll
    └── wine
        ├── bin
        ├── include
        ├── lib
        └── share
```
