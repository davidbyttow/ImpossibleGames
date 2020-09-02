using UnityEngine;
using System.Collections;

[RequireComponent(typeof(SpriteRenderer))]
public class BreakableBlock : MonoBehaviour {

	[SerializeField] private ParticleSystem breakEffect;

	private SpriteRenderer spriteRenderer;

	void Awake() {
		spriteRenderer = GetComponent<SpriteRenderer>();
	}

	void Update() {
	}

	private void OnCollisionEnter2D(Collision2D collision) {
		if (BumperBlock.IsBumpCollision(collision)) {
			Bump();
		}
	}

	private void Bump() {
		// TODO: Set the sprite if given
		var position = transform.position;
		Destroy(gameObject);
		if (breakEffect) {
			Instantiate(breakEffect, position, Quaternion.identity);
		}
	}
}
