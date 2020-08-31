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
		minBound = boundingBox.bounds.min;
		maxBound = boundingBox.bounds.max;
	}

	void LateUpdate() {
		var targetPosition = new Vector3(target.transform.position.x, target.transform.position.y, transform.position.z);
		var bounds = boundingBox.bounds;
		var position = Vector3.Lerp(transform.position, targetPosition, smoothing);

		var halfHeight = mainCamera.orthographicSize;
		var halfWidth = halfHeight * mainCamera.aspect;
		var x = Mathf.Clamp(position.x, minBound.x + halfWidth, maxBound.x - halfWidth);
		var y = Mathf.Clamp(position.y, minBound.y + halfHeight, maxBound.y - halfHeight);
		transform.position = new Vector3(x, y, transform.position.z);
	}
}
