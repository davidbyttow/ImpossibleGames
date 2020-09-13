using UnityEngine;
using System.Collections;

public class Exit : MonoBehaviour {

  public void ExitLevel() {
    GameManager.global.NextLevel();
  }
}
