using System;
using UnityEngine;


public interface HostRequest { }

[Serializable]
public struct OnLauncherStarted : HostRequest { }

[Serializable]
public struct OnGameStarted : HostRequest { }

[Serializable]
public struct LeaveGame : HostRequest { }

[Serializable]
public struct WinGame : HostRequest { }

[Serializable]
public struct EmptyMessage { }
