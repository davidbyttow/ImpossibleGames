﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class Player : MonoBehaviour {
	
	[SerializeField] private ParticleSystem deathEffect;
	[SerializeField] private Rigidbody2D head;

	private Rigidbody2D rigidBody;
	private SpriteRenderer sprite;
	private CharacterController controller;
	public bool isDead { get; private set; } = false;
	public bool isJumping { get; private set; } = false;

	private float horizontalInput = 0;
	private bool jumpRequested = false;
	private bool jumpCanceled = false;

	void Awake() {
		rigidBody = GetComponent<Rigidbody2D>();
		sprite = GetComponent<SpriteRenderer>();
		controller = GetComponent<CharacterController>();
	}

	void Start() {
		SoundManager.inst.PlayDoorClose();
	}

	void Update() {
		horizontalInput = Input.GetAxis("Horizontal");
		if (Input.GetButtonDown("Jump")) {
			jumpRequested = true;
		}
		if (Input.GetButtonUp("Jump")) {
			jumpCanceled = true;
		}
	}

	void FixedUpdate() {
		controller.Move(horizontalInput);

		if (jumpRequested && controller.isGrounded) {
			controller.Jump();
			isJumping = true;
			jumpRequested = false;
		}

		if (jumpCanceled && isJumping) {
			controller.CancelJump();
			isJumping = false;
			jumpCanceled = false;
		}
	}

	public void Die() {
		if (isDead) {
			return;
		}

		if (Camera.main.TryGetComponent(out CameraShake shake)) {
			shake.Shake();
		}

		if (deathEffect) {
			var effect = Instantiate(deathEffect, transform.position, Quaternion.Euler(0, -90, 0));
			effect.Play();
		}

		if (head) {
			var spawnedHead = Instantiate(head, transform.position, Quaternion.identity);
			spawnedHead.velocity = rigidBody.velocity;
			var angularVelocity = 20f + Random.value * 180f;
			spawnedHead.angularVelocity = rigidBody.velocity.x > 0 ? angularVelocity : -angularVelocity;
		}

		isDead = true;
		SoundManager.inst.PlayDeath();

		gameObject.SetActive(false);
		GameManager.global.QueueRestart();
	}
}
