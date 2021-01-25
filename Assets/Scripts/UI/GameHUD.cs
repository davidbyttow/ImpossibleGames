using UnityEngine;
using System.Collections;

public class GameHUD : MonoBehaviour {
  public void OnGiveUp() {
    GameManager.global.LeaveGame();
  }
}
