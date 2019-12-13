namespace LibForUnity

open FSharpPlus
open UnityEngine
open UnityEditor
open MeshEditor

module EditorFSharp =
    let button (s:string) f = if GUILayout.Button s then f ()

open EditorFSharp

type MeshCreatorEditor() =
    inherit EditorWindow()

    [<MenuItem("Custom/MeshCreator")>]
    static member Open() =
        EditorWindow.GetWindow<MeshCreatorEditor>("MeshCreator");

    member this.OnGUI() = 
        let v1 = transvalf0t1 10.f
        let v2 = transvalf0t1 20.f
        let vs = [v1; v2]
        let mesh = rand <| Vector3.one * 100.f <| vs
        0
