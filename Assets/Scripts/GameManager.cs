using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;
using System.Runtime.InteropServices;

#if UNITY_IOS
public class HostAPI {
  [DllImport("__Internal")]
  public static extern void hostLeaveGame();
}
#endif

public class GameManager : MonoBehaviour {

  public static GameManager global { get; private set; }

  [SerializeField] private AudioClip music;
  private float restartDelay = 0;

  void Awake() {
    if (global != null) {
      throw new System.Exception("More than one GameManager present in scene");
    }
    global = this;

#if UNITY_IOS
    Application.targetFrameRate = 60;
#endif
  }

  void Start() {
    StartMusic();
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

#if UNITY_IOS
    HostAPI.hostLeaveGame();
#endif
  }

  private void Restart() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
  }

  public void ExitLevel() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
  }
}
