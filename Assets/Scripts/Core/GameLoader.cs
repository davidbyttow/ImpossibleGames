using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

public class GameLoader : MonoBehaviour {

  public GameObject loadingScreen;

  public static GameLoader global { get; private set; }

  // TODO: Probably move this to a bundle manager
  private static Dictionary<String, AssetBundle> downloadedBundles = new Dictionary<String, AssetBundle>();

  private string scenePrefix = "scene:";
  private string testLoadParams = "scene:Tutorial01";

  // Test bundle: https://impossible-arcade.vercel.app/static/assets/bundles/dlctest01
  private string testBundle =
    "https://impossible-arcade.vercel.app/static/assets/bundles/dlc01_assets;https://impossible-arcade.vercel.app/static/assets/bundles/dlc01_scene";

  private float startLoadTime = 0;

  void Awake() {
    if (!global) {
      global = this;
      DontDestroyOnLoad(gameObject);
    } else {
      Destroy(gameObject);
    }
#if UNITY_IOS
    Application.targetFrameRate = 60;
#endif
    loadingScreen.SetActive(false);
  }

  void Start() {
    try {
      HostBridge.hostOnLauncherStarted();
    } catch (EntryPointNotFoundException) {
      LaunchGame(testLoadParams);
    }
  }

  public void LaunchGame(string encodedLoadParams) {
    loadingScreen.SetActive(true);
    Debug.Log("Launching game: " + encodedLoadParams);
    startLoadTime = Time.time;
    StartCoroutine(LoadSceneAsync(encodedLoadParams));
  }

  IEnumerator LoadSceneAsync(string encodedLoadParams) {
    UnloadBundles();

    yield return StartCoroutine(UnloadAllScenes());

    if (encodedLoadParams.StartsWith(scenePrefix)) {
      var sceneName = encodedLoadParams.Substring(scenePrefix.Length);
      Debug.Log("Scene provided: " + sceneName);
      yield return StartCoroutine(WaitMinTime());
      SceneManager.LoadScene(sceneName, LoadSceneMode.Additive);
      OnGameLoaded();
      yield return null;
    } else {
      Debug.Log("Bundles provided: " + encodedLoadParams);
      var bundleLocations = GetBundleUrls(encodedLoadParams);

      // First load assets
      if (bundleLocations.Length > 1) {
        for (var i = 0; i < bundleLocations.Length - 1; i++) {
          Coroutine2<AssetBundle> futureAssetBundle = new Coroutine2<AssetBundle>(this, LoadBundle(bundleLocations[i]));
          yield return futureAssetBundle.coroutine;
        }
      }

      // Next load the scene
      var sceneBundle = bundleLocations[bundleLocations.Length - 1];
      var bundleLocation = sceneBundle;

      Coroutine2<AssetBundle> futureSceneBundle = new Coroutine2<AssetBundle>(this, LoadBundle(bundleLocation));
      yield return futureSceneBundle.coroutine;
      var bundle = futureSceneBundle.result;

      if (!bundle.isStreamedSceneAssetBundle) {
        Debug.LogError("Bundle is not a streamed scene asset bundle");
        yield return null;
      }

      var sceneName = GetFirstSceneInBundle(bundle);
      if (sceneName == "") {
        Debug.LogError("No scene found in bundle");
        yield return null;
      }

      yield return StartCoroutine(WaitMinTime());

      SceneManager.LoadScene(sceneName);
      OnGameLoaded();
      yield return null;
    }
  }

  private void OnGameLoaded() {
    if (loadingScreen) {
      loadingScreen.SetActive(false);
    }
  }

  public void UnloadGame() {
    StartCoroutine(UnloadAllScenes());
    loadingScreen.SetActive(true);
  }

  private IEnumerator LoadBundle(string bundleLocation) {
    Debug.Log($"Loading asset bundle: {bundleLocation}");
    var req = UnityWebRequestAssetBundle.GetAssetBundle(bundleLocation);
    yield return req.SendWebRequest();

    if (req.result != UnityWebRequest.Result.Success) {
      Debug.Log($"Failed to load bundle: {req.error}");
      yield return null;
    }

    Debug.Log("Loading bundle: " + bundleLocation);
    var bundle = DownloadHandlerAssetBundle.GetContent(req);
    if (bundle != null) {
      downloadedBundles.Add(bundleLocation, bundle);
    }
    yield return bundle;
  }

  private IEnumerator WaitMinTime() {
    var remaining = Mathf.Max(2f - (Time.time - startLoadTime), 0);
    yield return new WaitForSeconds(remaining);
  }

  private string GetFirstSceneInBundle(AssetBundle bundle) {
    if (!bundle.isStreamedSceneAssetBundle) {
      return "";
    }
    var names = bundle.GetAllAssetNames();
    var scenePaths = bundle.GetAllScenePaths();
    var sceneName = System.IO.Path.GetFileNameWithoutExtension(scenePaths[0]);
    return sceneName;
  }

  private void UnloadBundles() {
    foreach (var item in downloadedBundles) {
      Debug.Log("Unloading bundle: " + item.Key);
      item.Value.Unload(true);
    }
    downloadedBundles.Clear();
  }

  private IEnumerator UnloadAllScenes() {
    Debug.Log("Unloading scenes");
    var thisScene = SceneManager.GetActiveScene();
    List<String> scenesToUnload = new List<String>();
    for (var i = 0; i < SceneManager.sceneCount; i++) {
      var scene = SceneManager.GetSceneAt(i);
      if (scene.name != thisScene.name) {
        scenesToUnload.Add(scene.name);
      }
    }
    foreach (var sceneName in scenesToUnload) {
      Debug.Log("Unloading scene: " + sceneName);
      yield return SceneManager.UnloadSceneAsync(sceneName);
    }
    yield return null;
  }

  private string[] GetBundleUrls(string encodedBundles) {
    var bundles = SplitString(encodedBundles);
    if (bundles.Length != 0) {
      return bundles;
    }
    Debug.Log("No bundles given, using test bundle");
    return SplitString(testBundle);
  }

  private string[] SplitString(string s) {
    return s.Split(';');
  }

  private void PrintDict<T, U>(Dictionary<T, U> dict) {
    var str = "";
    foreach (var item in dict) {
      str += "(" + item.Key + "," + item.Value + ") ";
    }
    Debug.Log(str);
  }
}