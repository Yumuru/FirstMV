module ObjExporter

open System.Text
open System.IO;
open FSharpPlus
open FSharpPlus.Data
open UnityEngine
open MeshEditor
open IO

let strAppend (sb:StringBuilder) (s:string) = sb.Append(s)
let gStrAppend f sb v = strAppend sb <| f v

let vertex2str (v : Vector3) =
    "v " + v.x.ToString() + " " + v.y.ToString() + " " + v.z.ToString() + "\n"

let uv2str (u : Vector2) =
    "vt " + u.x.ToString() + " " + u.y.ToString() + "\n"

let triangle2str (ts : int list) =
    let t1::t2::t3::_ = ts
    let t2str t = t.ToString()
    "f " + t2str t1 + " " + t2str t2 + " " + t2str t3 + "\n"

let set2str (f:'a -> string) ls =
    let sb = StringBuilder()
    List.fold (gStrAppend f) sb ls
        |> fun b -> b.ToString()

let vertices2str = set2str vertex2str
let triangles2str = set2str triangle2str
let uvs2str = set2str uv2str

let meshI2str name (mI:MeshInfo) =
    let vStr = vertices2str <| map (fun v -> v.vertex) mI.polys
    let tStr = triangles2str <| mI.triangles
    let uStr = uvs2str <| map (fun v -> v.uv) mI.polys
    let sb = StringBuilder()
    sb.Append("g " + name + "\n")
      .Append(vStr)
      .Append(uStr)
      .Append(tStr)
      .ToString()

let export path (name : string) mI = 
    IO (fun () -> File.WriteAllText(path+name, meshI2str name mI))
