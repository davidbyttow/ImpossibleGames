# ImpossibleGames

## Raw notes

Building for iOS:

- make sure to build the Unity IOS app (either iPhone or Device SDK depending on target) into iOS/UnityBuild location
- ensure Data folder is set to UnityFramework membership
- ensure NativeCallProxy.h is public

Asset Bundles:

- scenes and assets must be in separate bundles
- goes in impossible-arcade project
- they have to be pushed to prod (though reloading a new version of the same name seems to work)
- the string to the assets currently set in Unity code UnityPlayer


For M1:
- The project will want to build for arm64, make sure to set excluded architecture for any ios simulator to arm64 (for both unityframework target and native app, though the former may not be necessary?)