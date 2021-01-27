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

  [Serializable]
  public class Dog {
    public string name;
    public string owner;
  }

  void Start() {

    //var dog = new Dog();
    //dog.name = "Indy";
    //dog.owner = "Mark";
    //string json = JsonUtility.ToJson(dog);
    //Debug.Log(json);

    //HostBridge.hostCallMethod("TestMethod", json);

    Debug.Log("Starting game manager");

    HostBridge.Call(new OnGameStarted());
    HostBridge.hostOnGameStarted();
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
      HostBridge.Call(new WinGame());
      HostBridge.hostWinGame();
    } catch (EntryPointNotFoundException) {
      Debug.Log("Game won, but no host found so moving to next level");
      SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }
  }

  public void LeaveGame() {
    try {
      HostBridge.Call(new LeaveGame());
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
