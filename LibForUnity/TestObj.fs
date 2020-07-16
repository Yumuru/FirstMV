namespace TestMonoBehaviour

open FSharpPlus
open UnityEngine
open IO
open UnityIO

type TestObj() =
    inherit MonoBehaviour()
    [<SerializeField>]
    let mutable Speed = 0.f
    let counter() =
        let mutable i = 0.f
        IO(fun () -> i <- i+1.f; i)
