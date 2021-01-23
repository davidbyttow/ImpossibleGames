using System;
using System.Collections;
using UnityEngine;

public class Coroutine2<T> {
  public Coroutine coroutine { get; private set; }

  public T result;
  private IEnumerator target;

  public Coroutine2(MonoBehaviour owner, IEnumerator target) {
    this.target = target;
    this.coroutine = owner.StartCoroutine(Run());
  }

  private IEnumerator Run() {
    while (target.MoveNext()) {
      if (target.Current is T) {
        result = (T)target.Current;
      }
      yield return target.Current;
    }
  }
}