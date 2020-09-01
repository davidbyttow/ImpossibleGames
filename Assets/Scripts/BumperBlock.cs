using UnityEngine;
using System.Collections;

[RequireComponent(typeof(SpriteRenderer))]
public class BumperBlock : MonoBehaviour {

	private const float bumpDuration = 0.15f;
	private const float bumpOffset = 0.5f;

	[SerializeField] private Sprite bumpedSprite;

	private SpriteRenderer spriteRenderer;
	private float bumpAnimElapsed = 0;
	private bool bumped = false;
	private Vector3 restPosition = Vector3.zero;

	void Awake() {
		spriteRenderer = GetComponent<SpriteRenderer>();
	}

	void Update() {
		if (bumped && bumpAnimElapsed < bumpDuration) {
			bumpAnimElapsed += Time.deltaTime;
			float t = Mathf.Clamp(bumpAnimElapsed / bumpDuration, 0, 1f);
			transform.position = restPosition + Vector3.up * bumpOffset * Mathf.Sin(Mathf.PI * t);
		}
	}

	private void OnCollisionEnter2D(Collision2D collision) {
		if (collision.gameObject.tag == "Player") {
			for (var i = 0; i < collision.contactCount; ++i) {
				var contact = collision.GetContact(i);
				if (contact.normal == Vector2.up) {
					Bump();
					break;
				}
			}
		}
	}

	private void Bump() {
		if (bumped) {
			return;
		}
		bumped = true;
		spriteRenderer.sprite = bumpedSprite;
		restPosition = transform.position;
	}
}
