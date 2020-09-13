﻿using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Networking;
using System.Collections;
using System.Runtime.InteropServices;
using System.IO;

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
    //TestLocalDLC();
    Debug.Log("Starting game manager");
    StartCoroutine(TestRemoteDLC());
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

  private void TestLocalDLC() {
    // System.Environment.CommandLine
    var bundle = AssetBundle.LoadFromFile(Path.Combine(Application.dataPath, "AssetBundles", "dlctest01"));
    if (bundle == null) {
      Debug.Log("Failed to load asset bundle");
      return;
    }
    RunDLCScene(bundle);
  }

  IEnumerator TestRemoteDLC() {
    if (SceneManager.GetActiveScene().name.Contains("DLC")) {
      Debug.Log("Skipping");
      yield return null;
    }

    var req = UnityWebRequestAssetBundle.GetAssetBundle("https://davidbyttow.com/impossiblegames/assetbundles/dlctest01");
    Debug.Log("Sending web request");
    yield return req.SendWebRequest();
    if (req.result != UnityWebRequest.Result.Success) {
      Debug.Log($"Error: {req.error}");
    }

    Debug.Log("Downloading bundle");
    var bundle = DownloadHandlerAssetBundle.GetContent(req);
    Debug.Log("Loaded bundle");
    RunDLCScene(bundle);
    yield return null;
  }

  private void RunDLCScene(AssetBundle bundle) {
    Debug.Log("Running DLC Scene");
    if (bundle.isStreamedSceneAssetBundle) {
      var names = bundle.GetAllAssetNames();
      var scenePaths = bundle.GetAllScenePaths();
      var sceneName = System.IO.Path.GetFileNameWithoutExtension(scenePaths[0]);
      SceneManager.LoadScene(sceneName);
    }
  }

  public void LeaveGame() {
#if UNITY_IOS
    HostAPI.hostLeaveGame();
#else
    Application.Quit();
#endif
  }

  private void Restart() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
  }

  public void NextLevel() {
    SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
  }
}
