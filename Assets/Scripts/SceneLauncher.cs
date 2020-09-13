using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Networking;
using System.Collections;
using System.Runtime.InteropServices;
using System.IO;

public class SceneLauncher : MonoBehaviour {

  // Test bundle: https://davidbyttow.com/impossiblegames/assetbundles/dlctest01

  private float startLoadTime = 0;

  void Start() {
    startLoadTime = Time.time;
    StartCoroutine(LoadSceneAsync());
  }

  void Update() {
  }

  private string GetRequestedBundleUrl() {
    string[] args = System.Environment.GetCommandLineArgs();
    for (int i = 0; i < args.Length; i++) {
      if (args[i] == "-bundleUrl") {
        return args[i + 1];
      }
    }
    return "";
  }

  IEnumerator LoadSceneAsync() {
    string bundleLocation = GetRequestedBundleUrl();

    if (bundleLocation == "") {
      // Just load the next scene
      Debug.Log("No bundle URL provided, loading the next scene");
      yield return StartCoroutine(WaitMinTime());
      SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
      yield return null;
    }

    Debug.Log($"Loading asset bundle: {bundleLocation}");
    var req = UnityWebRequestAssetBundle.GetAssetBundle(bundleLocation);
    yield return req.SendWebRequest();

    if (req.result != UnityWebRequest.Result.Success) {
      Debug.Log($"Failed to load bundle: {req.error}");
      yield return null;
    }

    Debug.Log("Downloading bundle...");
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
