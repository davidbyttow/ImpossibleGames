using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Camera))]
public class FollowCamera : MonoBehaviour {

	[SerializeField] private Transform target;
	[SerializeField] private BoxCollider2D boundingBox;
	[SerializeField] private float smoothing = 0.5f;

	private Camera mainCamera;

	private Vector2 minBound;
	private Vector2 maxBound;
	
	void Awake() {
		mainCamera = GetComponent<Camera>();
	}

	void Start() {
		if (boundingBox) {
			minBound = boundingBox.bounds.min;
			maxBound = boundingBox.bounds.max;
		}
		transform.position = RestrictToBounds(target.transform.position);
	}

	void LateUpdate() {
		var position = Vector3.Lerp(transform.position, target.transform.position, smoothing);
		transform.position = RestrictToBounds(position);
	}
	
	private Vector3 RestrictToBounds(Vector3 target) {
		var x = target.x;
		var y = target.y;

		if (boundingBox) {		
			var bounds = boundingBox.bounds;
			var halfHeight = mainCamera.orthographicSize;
			var halfWidth = halfHeight * mainCamera.aspect;
			x = Mathf.Clamp(x, minBound.x + halfWidth, maxBound.x - halfWidth);
			y = Mathf.Clamp(y, minBound.y + halfHeight, maxBound.y - halfHeight);
		}

		return new Vector3(x, y, transform.position.z);
	}
}
