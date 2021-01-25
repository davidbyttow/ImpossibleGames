using System.Collections;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
public class ControlPlane : MonoBehaviour {

  public RectTransform leftControlGuide;
  public RectTransform rightControl;

  private TouchControls touchControls;
  private RectTransform bounds;

  void Start() {
    bounds = GetComponent<RectTransform>();
    touchControls = GetComponent<TouchControls>();
    if (leftControlGuide) {
      leftControlGuide.gameObject.SetActive(false);
    }
  }

  private void Update() {
    if (touchControls) {
      var leftActive = touchControls.leftControlActive;
      leftControlGuide.gameObject.SetActive(leftActive);
      if (leftActive) {
        // NOTE: This is brittle and assumes anchoed position is lower left screen location
        leftControlGuide.anchoredPosition = touchControls.leftControlPosition;
      }

      //touchControls.jumpButtonDown
    }
  }

}