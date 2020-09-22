using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Networking;
using System.Collections;
using System.Runtime.InteropServices;
using System.IO;


public interface HostApiInterface {
  void OnGameStart();
  void LeaveGame();
  string GetRequestedScene();
}

public class HostApi : HostApiInterface {
  private static HostApi inst;
  public static HostApi shared {
    get {
      if (inst == null) {
        inst = new HostApi();
      }
      return inst;
    }
  }

  public void OnGameStart() {
    Debug.Log("OnGameStart");
    hostOnGameStart();
  }
  public void LeaveGame() {
    Debug.Log("LeaveGame");
    hostLeaveGame();
  }
  public string GetRequestedScene() {
    Debug.Log("GetRequestedScene");
    return hostGetRequestedScene();
  }

#if UNITY_IOS
  [DllImport("__Internal")] public static extern void hostOnGameStart();
  [DllImport("__Internal")] public static extern void hostLeaveGame();
  [DllImport("__Internal")] public static extern string hostGetRequestedScene();
#else
  public static extern void hostOnGameStart() {}
  public static extern void hostLeaveGame() {
    Application.Quit();
  }
  public static extern string hostGetRequestedScene() { return "" }
#endif
}
