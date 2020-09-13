using System.IO;
using UnityEditor;

public class CreateAssetBundles {

  [MenuItem("Assets/Build AssetBundles")]
  static void BuildAllAssetBundles() {
    string dir = "Assets/AssetBundles";
    if (!Directory.Exists(dir)) {
      Directory.CreateDirectory(dir);
    }
    BuildPipeline.BuildAssetBundles(dir, BuildAssetBundleOptions.None, EditorUserBuildSettings.activeBuildTarget);
  }
}
