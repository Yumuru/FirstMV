module ObjExporter

open System.Text
open UnityEngine
open MeshEditor

let vertex2str (v : Vector3) =
    "v " + v.x.ToString() + v.y.ToString() + v.z.ToString()

let vertices2str vs =
    let sb = StringBuilder()
    List.fold (fun _ v -> sb.Append(vertex2str v); sb) sb vs
