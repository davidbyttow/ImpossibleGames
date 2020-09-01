using UnityEngine;
using System.Collections;

public class CameraShake : MonoBehaviour {

	[SerializeField] private float duration = 0.25f;
	[SerializeField] private float magnitude = 1f;

	private float timeLeft = 0.0f;
	private Vector3 initialPosition;

	void Update() {
		if (timeLeft > 0) {
			timeLeft -= Time.deltaTime;
			var rand = Random.insideUnitSphere;
			var pos = initialPosition + Random.insideUnitSphere * magnitude;
			transform.position = new Vector3(pos.x, pos.y, initialPosition.z);
			if (timeLeft <= 0) {
				transform.position = initialPosition;
			}
		}
	}

	public void Shake() {
		if (timeLeft <= 0) {
			timeLeft = duration;
			initialPosition = transform.position;
		}
	}
}

