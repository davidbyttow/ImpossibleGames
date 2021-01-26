using System.Collections;
using UnityEngine;

public class TouchControls : MonoBehaviour {

  private const float leftControlMaxDist = 140f;

  private RectTransform bounds;

  public bool leftControlActive {
    get {
      return mouseDown || leftTouchFinger >= 0;
    }
  }

  public Vector2 leftControlPosition {
    get {
      return leftTouchOrigin + leftControl * leftControlMaxDist;
    }
  }

  public float horizontal { get { return leftControl.x; } }
  public float vertical { get { return leftControl.y; } }
  public bool jumpButtonDown { get; private set; } = false;
  public bool jumpButtonUp { get; private set; } = false;

  private bool mouseDown;
  private Vector2 leftControl = Vector2.zero;
  private Vector2 leftTouchOrigin = Vector2.zero;
  private int leftTouchFinger = -1;
  private int rightTouchFinger = -1;

  private void Start() {
    bounds = GameObject.Find("ControlPlane").GetComponent<RectTransform>();
  }

  void Update() {
    var camera = Camera.main;
    if (!camera) {
      return;
    }

    var screenHalf = camera.pixelWidth * 0.5f;

    jumpButtonUp = false;
    jumpButtonDown = false;

    HandleLeftMouse();

    if (Input.touchCount > 0) {
      for (var i = 0; i < Input.touchCount; ++i) {
        var touch = Input.GetTouch(i);
        if (touch.position.x < screenHalf) {
          HandleLeftTouch(touch);
        } else if (touch.position.x > screenHalf) {
          HandleRightTouch(touch);
        }
      }
    }
  }

  private void HandleLeftMouse() {
    var pos = Input.mousePosition;

    if (Input.GetMouseButtonDown(0) && InsideTouchBounds(pos)) {
      mouseDown = true;
      leftTouchOrigin = pos;
      leftControl = Vector2.zero;
    } else if (mouseDown && Input.GetMouseButtonUp(0)) {
      mouseDown = false;
      leftControl = Vector2.zero;
    } else if (mouseDown) {
      leftControl.x = Mathf.Clamp((pos.x - leftTouchOrigin.x) / leftControlMaxDist, -1f, 1f);
      leftControl.y = Mathf.Clamp((pos.y - leftTouchOrigin.y) / leftControlMaxDist, -1f, 1f);
    }
  }

  private void HandleLeftTouch(Touch touch) {
    if (leftTouchFinger >= 0 && touch.fingerId != leftTouchFinger) {
      return;
    }

    if (touch.phase == TouchPhase.Began && InsideTouchBounds(touch.position)) {
      leftTouchFinger = touch.fingerId;
      leftTouchOrigin = touch.position;
      leftControl = Vector2.zero;
    }

    if (leftTouchFinger >= 0) {
      if (touch.phase == TouchPhase.Moved) {
        leftControl.x = Mathf.Clamp((touch.position.x - leftTouchOrigin.x) / leftControlMaxDist, -1f, 1f);
        leftControl.y = Mathf.Clamp((touch.position.y - leftTouchOrigin.y) / leftControlMaxDist, -1f, 1f);
      } else if (touch.phase == TouchPhase.Ended) {
        leftTouchFinger = -1;
        leftControl = Vector2.zero;
      }
    }
  }

  private void HandleRightTouch(Touch touch) {
    if (rightTouchFinger >= 0 && touch.fingerId != rightTouchFinger) {
      return;
    }

    if (touch.phase == TouchPhase.Began && InsideTouchBounds(touch.position)) {
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
