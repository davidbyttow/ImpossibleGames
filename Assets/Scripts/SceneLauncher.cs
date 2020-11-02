using System.Collections;
using System;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

public class SceneLauncher : MonoBehaviour {

  // Test bundle: https://davidbyttow.com/impossiblegames/assetbundles/dlctest01
  private string testBundle =
    "https://davidbyttow.com/impossiblegames/assetbundles/dlc01_assets;https://davidbyttow.com/impossiblegames/assetbundles/dlc01_scene";

  private float startLoadTime = 0;

  void Start() {
    startLoadTime = Time.time;
    StartCoroutine(LoadSceneAsync());
  }

  void Update() { }

  private string[] SplitString(string s) {
    return s.Split(';');
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

  IEnumerator LoadSceneAsync() {
    var bundleLocations = GetRequestedBundleUrls();

    if (bundleLocations.Length == 0) {
      // Just load the next scene
      Debug.Log("No bundle URL provided, loading the next scene");
      yield return StartCoroutine(WaitMinTime());
      SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
      yield return null;
    }

    // First load assets
    // TODO: DRY this up
    if (bundleLocations.Length > 1) {
      for (var i = 0; i < bundleLocations.Length - 1; i++) {
        var assetLoc = bundleLocations[i];
        Debug.Log($"Loading asset bundle: {assetLoc}");
        var assetReq = UnityWebRequestAssetBundle.GetAssetBundle(assetLoc);
        yield return assetReq.SendWebRequest();

        if (assetReq.result != UnityWebRequest.Result.Success) {
          Debug.Log($"Failed to load asset bundle: {assetReq.error}");
          yield return null;
        }

        Debug.Log("Downloading asset bundle...");
        DownloadHandlerAssetBundle.GetContent(assetReq);
      }
    }

    // Next load the scene
    var sceneBundle = bundleLocations[bundleLocations.Length - 1];
    var bundleLocation = sceneBundle;

    Debug.Log($"Loading scene bundle: {bundleLocation}");
    var req = UnityWebRequestAssetBundle.GetAssetBundle(bundleLocation);
    yield return req.SendWebRequest();

    if (req.result != UnityWebRequest.Result.Success) {
      Debug.Log($"Failed to load scene bundle: {req.error}");
      yield return null;
    }

    Debug.Log("Downloading scene bundle...");
    var bundle = DownloadHandlerAssetBundle.GetContent(req);

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

    Debug.Log("Downloading bundle...");
    var bundle = DownloadHandlerAssetBundle.GetContent(req);
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
}