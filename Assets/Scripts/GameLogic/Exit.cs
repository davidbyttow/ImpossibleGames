using UnityEngine;
using System.Collections;

public class Exit : MonoBehaviour {

  void OnTriggerEnter2D(Collider2D other) {
    if (other.TryGetComponent(out Player player)) {
      ExitLevel();
    }
  }

  public void ExitLevel() {
    GameManager.global.OnGameCompleted();
  }
}
