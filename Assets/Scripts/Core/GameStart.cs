using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;

public class GameStart : MonoBehaviour {

  void Awake() {
    if (!GameManager.global) {
      Debug.Log("Loading game harness");
      SceneManager.LoadScene("GameHarness", LoadSceneMode.Additive);
    }
  }

  void Start() {

  }

  void Update() {

  }
}
