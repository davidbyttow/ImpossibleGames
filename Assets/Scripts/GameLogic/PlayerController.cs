using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour {

  [SerializeField] private float horizontalSpeed = 10f;
  [SerializeField] private float inAirSpeedScale = 0.8f;
  [SerializeField] private float jumpForce = 400f;
  [SerializeField] private float jumpingGravityScale = 3f;
  [SerializeField] private float gravityScale = 4f;
  [Range(0, 0.3f)] [SerializeField] private float movementSmoothing = 0.05f;

  [SerializeField] private LayerMask groundMask;
  [SerializeField] private Transform groundCheck;
  [SerializeField] private float groundCheckRadius = 0.2f;
  [SerializeField] private Transform ceilingCheck;
  [SerializeField] private float ceilingCheckRadius = 0.2f;
  [SerializeField] private Transform wallCheck;
  [SerializeField] private float wallCheckRadius = 0.2f;

  public bool isGrounded { get; private set; }
  public bool isFacingWall { get; private set; }

  private Rigidbody2D rigidBody;
  private Animator animator;

  private bool facingRight = false;
  private float inAirStartTime = 0;
  private Vector3 velocity = Vector3.zero;

  void Awake() {
    rigidBody = GetComponent<Rigidbody2D>();
    rigidBody.gravityScale = gravityScale;
    rigidBody.isKinematic = false;
    rigidBody.freezeRotation = true;
    animator = GetComponent<Animator>();
  }

  void Start() {
    inAirStartTime = Time.time;
    facingRight = transform.localScale.x > 0;
  }

  void Update() {
    UpdateAnimation();
  }

  private void UpdateAnimation() {
    if (!animator) {
      return;
    }

    var walk = Mathf.Abs(rigidBody.velocity.x / horizontalSpeed);
    if (walk > 0) {
      walk = Mathf.Clamp(walk, 0.25f, 1f);
    }
    animator.SetFloat("Walk", walk);
  }

  void FixedUpdate() {
    CheckGround();

    if (!isGrounded && rigidBody.velocity.y < 0) {
      rigidBody.gravityScale = gravityScale;
    }
  }

  private void CheckGround() {
    bool wasGrounded = isGrounded;

    isGrounded = false;
    if (IsTouchingGroundOrWall(groundCheck.position, groundCheckRadius)) {
      isGrounded = true;
    }

    isFacingWall = false;
    if (!isGrounded && !wasGrounded) {
      if (IsTouchingGroundOrWall(wallCheck.position, wallCheckRadius)) {
        isFacingWall = true;
      }
    }

    if (wasGrounded && !isGrounded) {
      inAirStartTime = Time.time;
    }

    if (isGrounded && !wasGrounded) {
      if (Time.time - inAirStartTime > 0.2f) {
        // Re-using the jump sound
        SoundManager.global.PlayJump();
      }
    }
  }

  private bool IsTouchingGroundOrWall(Vector3 position, float radius) {
    Collider2D[] colliders = Physics2D.OverlapCircleAll(position, radius, groundMask);
    foreach (Collider2D collider in colliders) {
      if (collider.gameObject != gameObject && !collider.isTrigger) {
        return true;
      }
    }
    return false;
  }

  public void Move(float horizontalInput) {
    var horizontalVelocity = horizontalInput * horizontalSpeed * (isGrounded ? 1f : inAirSpeedScale);
    Vector3 targetVelocity = new Vector2(horizontalVelocity, rigidBody.velocity.y);
    rigidBody.velocity = Vector3.SmoothDamp(rigidBody.velocity, targetVelocity, ref velocity, movementSmoothing);

    if ((horizontalInput > 0 && !facingRight) || (horizontalInput < 0 && facingRight)) {
      Flip();
    }

    if (isFacingWall && !isGrounded) {
      rigidBody.velocity = new Vector2(0, rigidBody.velocity.y);
    }
  }

  public void Jump() {
    if (isGrounded) {
      SoundManager.global.PlayJump();
      isGrounded = false;
      rigidBody.AddForce(new Vector2(0, jumpForce));
      rigidBody.gravityScale = jumpingGravityScale;
      inAirStartTime = Time.time;
    }
  }

  private void Flip() {
    facingRight = !facingRight;

    Vector3 scale = transform.localScale;
    scale.x *= -1;
    transform.localScale = scale;
  }

  public void CancelJump() {
    if (!isGrounded) {
      rigidBody.gravityScale = gravityScale;
      var damping = rigidBody.velocity.y > 0 ? 0.5f : 1f;
      rigidBody.velocity = new Vector2(rigidBody.velocity.x, rigidBody.velocity.y * damping);
    }
  }

  void OnDrawGizmosSelected() {
    if (groundCheck) {
      Gizmos.color = Color.yellow;
      Gizmos.DrawWireSphere(groundCheck.position, groundCheckRadius);
    }

    if (ceilingCheck) {
      Gizmos.color = Color.red;
      Gizmos.DrawWireSphere(ceilingCheck.position, ceilingCheckRadius);
    }

    if (ceilingCheck) {
      Gizmos.color = Color.red;
      Gizmos.DrawWireSphere(wallCheck.position, wallCheckRadius);
    }
  }
}
