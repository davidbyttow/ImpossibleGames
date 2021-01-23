using System.Runtime.InteropServices;

public class HostApi {

#if UNITY_IOS
  [DllImport("__Internal")] public static extern void hostOnLauncherStarted();
  [DllImport("__Internal")] public static extern void hostOnGameStarted();
  [DllImport("__Internal")] public static extern void hostLeaveGame();
  [DllImport("__Internal")] public static extern void hostWinGame();
#else
  public static void hostOnLauncherStarted() {}
  public static void hostOnGameStarted() {}
  public static void hostLeaveGame() {
    //Application.Quit();
  }
  public static void hostWinGame() {}
#endif
}
