namespace LibForUnity

open FSharpPlus
open UnityEngine
open UnityEditor
open MeshEditor
open ObjExporter
open CreateMesh
open IO

module EditorFSharp =
    let button (s:string) io = if GUILayout.Button s then iorun io

open EditorFSharp

type MeshCreatorEditor() =
    inherit EditorWindow()
    let mutable Scale = Vector3.one
    let mutable V1 = Vector2.one
    let mutable V2 = Vector2.one
    let mutable V3 = Vector2.one
    let mutable FileName = ""

    [<MenuItem("Custom/MeshCreator")>]
    static member Open() =
        EditorWindow.GetWindow<MeshCreatorEditor>("MeshCreator");

    member this.OnGUI() = 
        Scale <- EditorGUILayout.Vector3Field("Scale", Scale)
        V1 <- EditorGUILayout.Vector2Field("UV1 from0", V1)
        V2 <- EditorGUILayout.Vector2Field("UV2 from0", V2)
        V3 <- EditorGUILayout.Vector2Field("UV3 Int", V3)
        FileName <- EditorGUILayout.TextField("FileName", FileName)
        button "Generate Random Mesh" <| monad {
            do! iou
            let tups = List.map vec2tup [V1; V2; V3]
            let polys = randPoly tups Scale
            return! export "Assets/" FileName <| polys2mesh polys
        }

        button "genFirstMelogyObj" <| monad {
            do! iou
            let! polys = firstMelogyObj (float32 V1.x) (float32 V1.y) Scale
            return! export "Assets/" "FirstMelodyCubes.obj" <| polys2mesh polys
        }

        button "genBox" <| monad {
            do! iou
            let polys = box Scale
            return! export "Assets/" FileName <| polys2mesh polys
        }

        button "randomlaser" <| monad{
            do! iou
            let polys = randomlaser (float32 V1.x) (float32 V1.y) Scale
            return! export "Assets/" "RandomLaser.obj" <| polys2mesh polys
        }

        button "hexobj" <| monad{
            do! iou
            let polys = hexobjs V1.x V1.y V2.x V2.y V3.x
            return! export "Assets/" "HexagonalObj.obj" <| polys2mesh polys
        }
