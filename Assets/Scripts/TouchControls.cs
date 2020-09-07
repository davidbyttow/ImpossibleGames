using System.Collections;
using UnityEngine;

public class TouchControls : MonoBehaviour {

  private const float leftControlMaxDist = 140f;

  public float horizontal { get; private set; } = 0;
  public bool jumpButtonDown { get; private set; } = false;
  public bool jumpButtonUp { get; private set; } = false;

  private Vector2 leftTouchOrigin;
  private int leftTouchFinger = -1;
  private int rightTouchFinger = -1;

  void Update() {
    var camera = Camera.main;

    var screenHalf = camera.pixelWidth * 0.5f;

    jumpButtonUp = false;
    jumpButtonDown = false;

    if (Input.touchCount > 0) {
      for (var i = 0; i < Input.touchCount; ++i) {
        var touch = Input.GetTouch(i);
        if (touch.position.x < screenHalf) {
          HandleLeftTouch(touch);
        } else if (touch.position.x > screenHalf) {
          HandleRightTouch(touch);
        }
      }
      // Debug.Log($"Position: {touch.position} {screenWidth}");
    }
  }

  private void HandleLeftTouch(Touch touch) {
    if (leftTouchFinger >= 0 && touch.fingerId != leftTouchFinger) {
      return;
    }

    if (touch.phase == TouchPhase.Began) {
      leftTouchFinger = touch.fingerId;
      leftTouchOrigin = touch.position;
      horizontal = 0;
    } else if (touch.phase == TouchPhase.Moved) {
      var dist = touch.position.x - leftTouchOrigin.x;
      horizontal = Mathf.Clamp(dist / leftControlMaxDist, -1f, 1f);
    } else if (touch.phase == TouchPhase.Ended) {
      leftTouchFinger = -1;
      horizontal = 0;
    }
  }

  private void HandleRightTouch(Touch touch) {
    if (rightTouchFinger >= 0 && touch.fingerId != rightTouchFinger) {
      return;
    }

    if (touch.phase == TouchPhase.Began) {
      rightTouchFinger = touch.fingerId;
      jumpButtonDown = true;
    } else if (touch.phase == TouchPhase.Ended) {
      rightTouchFinger = -1;
      jumpButtonUp = true;
    }
  }
}
