module MeshEditor

open UnityEngine
open FSharpPlus
open FSharpPlus.Data
open IO

type Vertex = {
        vertex : Vector3
        uv : Vector2
    }
type Polygon = Vertex list
type MeshInfo = {
        polys : Vertex list
        triangles : int list list
    }
    
let makerange b f n = [b..f b n]
let transvalue rate n = List.map (rate n) <| [0.f..n-1.f]

let ratef0 mn n = n / mn
let ratef0t1 mn n = n / mn-1.f

let transvalf0t1 = transvalue ratef0t1
let transvalf0 = transvalue ratef0

let fvec2 f = IO (fun () -> Vector2(iorun f, iorun f))
let fvec3 f = IO (fun () -> Vector3(iorun f, iorun f, iorun f))
let random = IO (fun () -> Random.value)
let randomV2 = fvec2 ((fun v -> v - 0.5f) <<| random)
let randomV3 = fvec3 ((fun v -> v - 0.5f) <<| random)

let counter = IO (fun () -> 
    let mutable i = 0
    IO (fun () -> i <- i+1; i))

let polys2mesh (polys:Polygon list) =
    let c = iorun counter
    let triangles = List.map (List.map (fun _ -> iorun c)) polys
    { polys = List.concat polys; triangles = triangles }

let pointpoly c =
    let rot = Quaternion.AngleAxis(120.f, Vector3.up)
    let d = Vector3.forward * 0.001f
    [c + d; c + rot * d; c + rot * rot * d]

let pointpolyo o = pointpoly (o - Vector3.forward * 0.001f)

let vertex vert uv = { vertex = vert; uv = uv }
let makepoly verts uv = List.map2 vertex verts uv : Polygon
let polygon verts = verts : Polygon

let polyverts (poly:Polygon) = map (fun v -> v.vertex) poly
let polyuv (poly:Polygon) = map (fun v -> v.uv) poly
let polytuple (poly:Polygon) = (polyverts poly, polyuv poly)

let tup2vec2 (x, y) = Vector2(x, y)
let tup2vec3 (x, y, z) = Vector3(x, y, z)

let updatevec2 (u1, u2) (vec:Vector2) =
    Vector2(u1 vec.x, u2 vec.y)
let updatevuv update (vertex:Vertex) =
    { vertex with uv = updatevec2 update vertex.uv }
let updatepoly updatev updateuv (poly:Polygon) = 
    let (verts, uv) = polytuple poly
    let updateuvvec = List.map updatevec2 updateuv
    let vs = List.map2 (<|) updatev verts
    let us = List.map2 (<|) updateuvvec uv
    makepoly vs us
let updatevertex update = updatepoly update [(id,id);(id,id);(id,id);(id,id)]
let updateuv update = updatepoly [id;id;id;id] <| update
let transpoly trans = updatevertex [trans; trans; trans]

let randposverts = pointpoly <!> randomV3

let square =
    let vs = [|
        Vector3(-0.5f, -0.5f, 0.f)
        Vector3(-0.5f, 0.5f, 0.f)
        Vector3(0.5f, 0.5f, 0.f)
        Vector3(0.5f, -0.5f, 0.f) |]
    let vertex i = vs.[i]
    let poly ls = map vertex ls
    [poly [0; 1; 3]; poly [2; 3; 1]]
    
let cube =
    let maketrans f v = f (v + Vector3.back / 2.f)
    let rot1 v = Quaternion.AngleAxis(90.f, Vector3.up) * v
    let rot2 v = Quaternion.AngleAxis(90.f, Vector3.right) * v
    let trans f = List.map (List.map f) square
    List.concat [
        trans (maketrans id)
        trans (maketrans rot1) 
        trans (maketrans (rot1 << rot1)) 
        trans (maketrans (rot1 << rot1 << rot1)) 
        trans (maketrans (rot1 << rot1 << rot1)) 
        trans (maketrans rot2) 
        trans (maketrans (rot2 << rot2 << rot2)) ]
