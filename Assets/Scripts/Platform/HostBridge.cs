using System;
using System.Runtime.InteropServices;
using UnityEngine;

public class HostBridge : MonoBehaviour {

  public static HostBridge global { get; private set; }

  void Awake() {
    if (!global) {
      global = this;
      DontDestroyOnLoad(gameObject);
    } else {
      Destroy(gameObject);
    }
  }

  void LaunchGame(string encodedLoadParams) {
    GameLoader.global.LaunchGame(encodedLoadParams);
  }

  void LoadLauncher(string message) {
    GameLoader.global.UnloadGame();
  }

  public static void Call(HostRequest req) {
    var method = req.GetType().Name;
    string messageJson = JsonUtility.ToJson(req);
    Debug.Log("Call: " + method + ": " + messageJson);

    try {
      hostCallMethod(method, messageJson);
    } catch (EntryPointNotFoundException) {
      Debug.Log("hostCallMethod not found");
    }
  }

#if UNITY_IOS
  [DllImport("__Internal")] public static extern void hostOnLauncherStarted();
  [DllImport("__Internal")] public static extern void hostOnGameStarted();
  [DllImport("__Internal")] public static extern void hostLeaveGame();
  [DllImport("__Internal")] public static extern void hostWinGame();
  [DllImport("__Internal")] public static extern void hostCallMethod(string method, string messageJson);
#else
  public static void hostOnLauncherStarted() {}
  public static void hostOnGameStarted() {}
  public static void hostLeaveGame() {
    //Application.Quit();
  }
  public static void hostWinGame() {}
  public static void hostCallMethod(string method, string messageJson) {}
#endif

}
