module UnityIO

open UnityEngine
open IO

let dlog str = IO(fun () -> Debug.Log str)
