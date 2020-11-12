using System;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {

  public static GameManager global { get; private set; }

  [SerializeField] private AudioClip music;
  private float restartDelay = 0;

  void Awake() {
#if UNITY_IOS
    Application.targetFrameRate = 60;
#endif
  }

  void Start() {
    HostApi.hostOnGameStarted();
    StartMusic();
    Debug.Log("Starting game manager");
  }

  void StartMusic() {
    if (music && Music.inst) {
      Music.inst.MaybePlay(music);
    }
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

  public void LeaveGame() {
    try {
      HostApi.hostLeaveGame();
    } catch (EntryPointNotFoundException e) {
      // Nothing to do
    }
  }

  public void LoadLauncher(string message) {
    SceneManager.LoadScene(0);
  }

  private void Restart() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
  }

  public void NextLevel() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
  }
}
