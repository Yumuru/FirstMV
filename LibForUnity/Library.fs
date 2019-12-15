namespace LibForUnity

open FSharpPlus
open FSharpPlus.Data
open UnityEngine
open UnityEditor
open MeshEditor
open ObjExporter
open IO

module EditorFSharp =
    let button (s:string) io = if GUILayout.Button s then iorun io
    let random = IO (fun () -> Random.value)
    let random2 () = Random.value

open EditorFSharp

type MeshCreatorEditor() =
    inherit EditorWindow()
    member val Scale = Vector3.one with get, set
    member val V1 = Vector2Int.one with get, set
    member val V2 = Vector2Int.one with get, set
    member val V3 = Vector2Int.one with get, set

    [<MenuItem("Custom/MeshCreator")>]
    static member Open() =
        EditorWindow.GetWindow<MeshCreatorEditor>("MeshCreator");

    member this.OnGUI() = 
        this.Scale <- EditorGUILayout.Vector3Field("Scale", this.Scale)
        this.V1 <- EditorGUILayout.Vector2IntField("UV1 from0", this.V1)
        this.V2 <- EditorGUILayout.Vector2IntField("UV2 from0", this.V2)
        this.V3 <- EditorGUILayout.Vector2IntField("UV3 Int", this.V3)
        button "Generate Random Mesh" (monad {
            let uvs = monad {
                let! v1 = transvalf0 << float32 <| this.V1.x
                let! v2 = transvalf0 << float32 <| this.V1.y
                let! v3 = transvalf0 << float32 <| this.V2.x
                let! v4 = transvalf0 << float32 <| this.V2.y
                let! v5 = [0.f..float32 this.V3.x - 1.f]
                let! v6 = [0.f..float32 this.V3.y - 1.f]
                return map tup2vec2 [(v1, v2); (v3, v4); (v5, v6)]
            }
            let makep uv = makepoly <!> randposverts <*> iocons uv
            let polys = sequence <| List.map makep uvs
            return! export "Assets/" "test.obj" =<< (polys2mesh <!> polys)
        })

        button "CubeTest" (monad {
            let verts = map (map (fun v -> Vector3.Scale(v, this.Scale))) cube
            let genuvs u = map tup2vec2 [ (0.f, 0.f); (u, 0.f); (0.f, 0.f)]
            let uvs = map genuvs [0.f..10.f]
            let makecube uv = map (fun vs -> makepoly vs uv) verts
            let cubes = List.map makecube <| uvs
            let polys = List.concat cubes
            return! export "Assets/" "test.obj" <| polys2mesh polys
        })
        0
