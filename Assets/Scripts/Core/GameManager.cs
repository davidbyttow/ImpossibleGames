using System;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {

  public static GameManager global { get; private set; }

  private float restartDelay = 0;

  void Awake() {
    if (!global) {
      global = this;
      DontDestroyOnLoad(gameObject);
    } else {
      Destroy(gameObject);
    }
  }

  void Start() {
    HostBridge.hostOnGameStarted();
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

  public void OnGameCompleted() {
    try {
      HostBridge.hostWinGame();
    } catch (EntryPointNotFoundException) {
      Debug.Log("Game won, but no host found so moving to next level");
      SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }
  }

  public void LeaveGame() {
    try {
      HostBridge.hostLeaveGame();
    } catch (EntryPointNotFoundException) {
      // Nothing to do
      Debug.Log("Game quit, but no host found");
      GameLoader.global.UnloadGame();
    }
  }

  private void Restart() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().name);
  }
}
