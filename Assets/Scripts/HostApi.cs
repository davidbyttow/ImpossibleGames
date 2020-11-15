using System.Runtime.InteropServices;

public class HostApi {

#if UNITY_IOS
  [DllImport("__Internal")] public static extern void hostOnLauncherStarted();
  [DllImport("__Internal")] public static extern void hostOnGameStarted();
  [DllImport("__Internal")] public static extern void hostLeaveGame();
#else
  public static extern void hostOnLauncherStarted() {}
  public static extern void hostOnGameStarted() {}
  public static extern void hostLeaveGame() {
    Application.Quit();
  }
#endif
}
