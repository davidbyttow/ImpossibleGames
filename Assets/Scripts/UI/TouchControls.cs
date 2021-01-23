using System.Collections;
using UnityEngine;

public class TouchControls : MonoBehaviour {

  private const float leftControlMaxDist = 140f;

  private RectTransform bounds;

  public float horizontal { get; private set; } = 0;
  public bool jumpButtonDown { get; private set; } = false;
  public bool jumpButtonUp { get; private set; } = false;

  private Vector2 leftTouchOrigin;
  private int leftTouchFinger = -1;
  private int rightTouchFinger = -1;

  private void Start() {
    bounds = GameObject.Find("ControlPlane").GetComponent<RectTransform>();
  }

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
        }
        else if (touch.position.x > screenHalf) {
          HandleRightTouch(touch);
        }
      }
    }
  }

  private void HandleLeftTouch(Touch touch) {
    if (leftTouchFinger >= 0 && touch.fingerId != leftTouchFinger) {
      return;
    }

    if (touch.phase == TouchPhase.Began && InsideTouchBounds(touch.position)) {
      leftTouchFinger = touch.fingerId;
      leftTouchOrigin = touch.position;
      horizontal = 0;
    }

    if (leftTouchFinger >= 0) {
      if (touch.phase == TouchPhase.Moved) {
        var dist = touch.position.x - leftTouchOrigin.x;
        horizontal = Mathf.Clamp(dist / leftControlMaxDist, -1f, 1f);
      }
      else if (touch.phase == TouchPhase.Ended) {
        leftTouchFinger = -1;
        horizontal = 0;
      }
    }
  }

  private void HandleRightTouch(Touch touch) {
    if (rightTouchFinger >= 0 && touch.fingerId != rightTouchFinger) {
      return;
    }

    if (touch.phase == TouchPhase.Began && InsideTouchBounds(touch.position)) {
      Debug.Log($"Touch right: {touch.fingerId}");
      rightTouchFinger = touch.fingerId;
      jumpButtonDown = true;
    }

    if (rightTouchFinger >= 0) {
      if (touch.phase == TouchPhase.Ended) {
        rightTouchFinger = -1;
        jumpButtonUp = true;
      }
    }
  }

  private bool InsideTouchBounds(Vector2 point) {
    return !bounds || RectTransformUtility.RectangleContainsScreenPoint(bounds, point);
    // var isInside = !bounds || bounds.rect.Contains(point);
    // Debug.Log($"{bounds} {bounds.rect} {point} Contains={isInside}");
    // return isInside;
  }
}
