using System.Collections;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
public class ControlPlane : MonoBehaviour {

  private RectTransform rectTransform;

  void Awake() {
    rectTransform = GetComponent<RectTransform>();
    var pixelRect = Camera.main.pixelRect;
  }

}