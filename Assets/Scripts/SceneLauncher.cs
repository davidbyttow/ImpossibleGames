using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

public class SceneLauncher : MonoBehaviour {

  private static SceneLauncher global;
  private bool launched = false;

  // TODO: Probably move this to a bundle manager
  private static Dictionary<String, AssetBundle> downloadedBundles = new Dictionary<String, AssetBundle>();

  // Test bundle: https://davidbyttow.com/impossiblegames/assetbundles/dlctest01
  private string testBundle =
    "https://davidbyttow.com/impossiblegames/assetbundles/dlc01_assets;https://davidbyttow.com/impossiblegames/assetbundles/dlc01_scene";

  private float startLoadTime = 0;

  void Start() {
    HostApi.hostOnLauncherStarted();
  }

  void LaunchGame(string bundle) {
    Debug.Log("Launching bundle: " + bundle);
    startLoadTime = Time.time;
    StartCoroutine(LoadSceneAsync());
  }

  IEnumerator LoadSceneAsync() {
    UnloadBundles();

    Debug.Log("Loading requested scene");
    yield return StartCoroutine(UnloadAllScenes());

    var bundleLocations = GetRequestedBundleUrls();

    if (bundleLocations.Length == 0) {
      // Just load the next scene
      Debug.Log("No bundle URL provided, loading the next scene");
      yield return StartCoroutine(WaitMinTime());
      SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
      yield return null;
    }

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
    yield return null;
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

  private string[] GetRequestedBundleUrls() {
    string[] args = System.Environment.GetCommandLineArgs();
    for (int i = 0; i < args.Length; i++) {
      if (args[i] == "-bundleUrl") {
        return SplitString(args[i + 1]);
      }
    }
    Debug.Log("No bundle URL found, falling back to plugin");
    try {
      return SplitString(HostApi.hostGetRequestedScene());
    } catch (EntryPointNotFoundException e) {
      Debug.Log("No entry found, falling back");
      return SplitString(testBundle);
    }
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