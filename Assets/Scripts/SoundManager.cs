using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class SoundManager : MonoBehaviour {

	public static SoundManager inst { get; private set; }

	public AudioClip[] jumpSounds;
	public AudioClip[] landSounds;
	public AudioClip[] swooshSounds;
	public AudioClip[] deathSounds;
	public AudioClip[] doorCloseSounds;

	private AudioSource source;

	void Awake() {
		if (!inst) {
			inst = this;
			DontDestroyOnLoad(gameObject);
		} else {
			Destroy(gameObject);
		}
		source = GetComponent<AudioSource>();
	}

	public void PlayJump() {
		PlaySound(jumpSounds);
	}

	public void PlayLand() {
		PlaySound(landSounds);
	}

	public void PlaySwoosh() {
		PlaySound(swooshSounds);
	}

	public void PlayDeath() {
		PlaySound(deathSounds);
	}

	public void PlayDoorClose() {
		PlaySound(doorCloseSounds);
	}

	public AudioClip Pick(AudioClip[] clips) {
		return clips[Random.Range(0, clips.Length)];
	}

	private void PlaySound(AudioClip[] clips) {
		if (clips != null && clips.Length > 0) {
			source.PlayOneShot(Pick(clips));
		}
	}

	private void PlaySound(AudioClip clip) {
		if (clip) {
			source.PlayOneShot(clip);
		}
	}
}
