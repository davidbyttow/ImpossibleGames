using System;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {

  public static GameManager global { get; private set; }

  private float restartDelay = 0;

  void Awake() {
    global = this;

#if UNITY_IOS
    Application.targetFrameRate = 60;
#endif
  }

  void Start() {
    HostApi.hostOnGameStarted();
    Debug.Log("Starting game manager");
  }

  void Update() {
    if (restartDelay > 0) {
      restartDelay -= Time.deltaTime;
      if (restartDelay <= 0) {
        Restart();
      }
    }
    if (Input.GetKeyDown(KeyCode.Tab)) {
      Restart();
    }
  }

  public void QueueRestart() {
    restartDelay = 1.5f;
  }

  public void WinGame() {
    try {
      HostApi.hostWinGame();
    }
    catch (EntryPointNotFoundException) {
      Debug.Log("Game won, but no host found so moving to next level");
      SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }
  }

  public void LeaveGame() {
    try {
      HostApi.hostLeaveGame();
    }
    catch (EntryPointNotFoundException) {
      // Nothing to do
      Debug.Log("Game quit, but no host found");
    }
  }

  public void LoadLauncher(string message) {
    SceneManager.LoadScene(0);
  }

  private void Restart() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().name);
  }
}
