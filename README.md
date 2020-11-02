# ImpossibleGames

## Raw notes

Building for iOS:

- make sure to build the Unity IOS app (either iPhone or Device SDK depending on target) into iOS/UnityBuild location
- ensure Data folder is set to UnityFramework membership
- ensure NativeCallProxy.h is also public

Asset Bundles:

- scenes and assets must be in separate bundles
- for testing, add to davidbyttow.com/impossiblegames/assetbundles
- they have to be pushed to prod (though reloading a new version of the same name seems to work)
- the string to the assets currently set in Unity code UnityPlayer
