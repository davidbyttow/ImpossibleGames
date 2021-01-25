using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class Music : MonoBehaviour {

	public static Music inst { get; private set; }

	void Awake() {
		if (!inst) {
			inst = this;
			DontDestroyOnLoad(gameObject);
		} else {
			Destroy(gameObject);
		}
		source = GetComponent<AudioSource>();
	}

	public void MaybePlay(AudioClip clip) {
		Debug.Log("Play?");
		if (!source.clip || source.clip.name != clip.name) {
			source.Stop();
			source.clip = clip;
			source.Play();
			Debug.Log("Playing");
		}
	}

	private AudioSource source;
}
