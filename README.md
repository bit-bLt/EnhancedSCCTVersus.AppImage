## Build Process

1. Place game in opt/game/

2. Place wine in opt/wine/

3. Add 32bit dxvk (d3d9.dll) to game system folder

4. Add 32bit dsoal (dsound.dll, dsoal-aldrv.dll, alsoft.ini) to game system folder

5. Modify alsoft.ini as needed

6. Ensure icon.png in root of EnhancedSCCTVersus.AppDir

7. Run ./build.sh


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
