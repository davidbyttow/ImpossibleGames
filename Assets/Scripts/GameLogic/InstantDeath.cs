using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstantDeath : MonoBehaviour {

  void OnCollisionEnter2D(Collision2D collision) {
    var other = collision.collider;
    CheckCollision(other);
  }


  void OnTriggerEnter2D(Collider2D other) {
    CheckCollision(other);
  }

  void CheckCollision(Collider2D other) {
    if (other.TryGetComponent(out Player player)) {
      player.Die();
    }
  }
}
