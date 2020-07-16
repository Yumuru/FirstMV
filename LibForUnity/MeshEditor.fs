module MeshEditor

open UnityEngine
open FSharpPlus
open FSharpPlus.Data
open IO

type Polygon = {
        vertices : Vector3 list
        normals : Vector3 list
        uvs : Vector2 list
    }
let polygon vs ns us = { vertices = vs; normals = ns; uvs = us }
let vertices p = p.vertices
let normals p = p.normals
let puvs p = p.uvs

type MeshInfo = {
        polys : Polygon list
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
let randomV2 = fvec2 ((fun v -> v - 0.5f) <!> random)
let randomV3 = fvec3 ((fun v -> v - 0.5f) <!> random)

let counter () = 
    let mutable i = 0
    (fun () -> i <- i+1; i)

let polys2mesh (polys:Polygon list) =
    let tri i _ = i
    let getverts p = p.vertices
    let vertices = List.map getverts polys
    let c = counter ()
    let triangles = List.map (List.map (fun v -> c())) vertices
    { polys = polys; triangles = triangles }

let pointpolyv =
    let rot = Quaternion.AngleAxis(120.f, Vector3.up)
    let d = Vector3.forward * 0.01f
    [d; rot * d; rot * rot * d]

let pointpolyvo = List.map ((-) <| Vector3.forward * 0.001f) pointpolyv

let tup2vec2 (x, y) = Vector2(x, y)
let tup2vec3 (x, y, z) = Vector3(x, y, z)
let vec2tup (v:Vector2) = (v.x, v.y)
let veci2tup (v:Vector2Int) = (v.x, v.y)
let vec3tup (v:Vector3) = (v.x, v.y, v.z)
let veci3tup (v:Vector3Int) = (v.x, v.y, v.z)

let updatevec2 (u1, u2) (vec:Vector2) =
    Vector2(u1 vec.x, u2 vec.y)

let square (xv:Vector3) (yv:Vector3) =
    let vs = [|
        -xv*0.5f-yv*0.5f
        -xv*0.5f+yv*0.5f
        xv*0.5f+yv*0.5f
        xv*0.5f-yv*0.5f |]
    let vertex i = vs.[i]
    let poly ls = map vertex ls
    [poly [0; 1; 3]; poly [2; 3; 1]]
    
let cube =
    let maketrans f v = f (v + Vector3.back / 2.f)
    let rot1 v = Quaternion.AngleAxis(90.f, Vector3.up) * v
    let rot2 v = Quaternion.AngleAxis(90.f, Vector3.right) * v
    let trans f = List.map (List.map f) <| square Vector3.right Vector3.up
    List.concat [
        trans (maketrans id)
        trans (maketrans rot1) 
        trans (maketrans (rot1 << rot1)) 
        trans (maketrans (rot1 << rot1 << rot1)) 
        trans (maketrans (rot1 << rot1 << rot1)) 
        trans (maketrans rot2) 
        trans (maketrans (rot2 << rot2 << rot2)) ]

let circleps n (axis:Vector3) (fwd:Vector3) =
    let rot i = Quaternion.AngleAxis(360.f / (n) * i, axis)
    let makep i = rot i * fwd
    List.map makep [0.f..n]

let circle n (axis:Vector3) (fwd:Vector3) =
    let points = circleps n axis fwd
    let makevs v1 v2 = [Vector3.zero; v1; v2]
    List.map2 makevs (List.rev << List.tail << List.rev <| points) <| List.tail points

let tube n (upv:Vector3) (fwd:Vector3) height =
    let circ = circleps n upv fwd
    let rec makeside ps = match ps with
        | p1::p2::p ->
            let offsetv = (p1 + p2) : Vector3
            let offset = offsetv / 2.f
            let vs = square (p1-p2) (upv * height) |> List.map (List.map (offset |> (+)))
            vs::makeside (p2::p)
        | _  -> []
    List.concat <| makeside circ

let cone n (upv:Vector3) (fwd:Vector3) height =
    let circ = circleps n upv fwd
    let rec makeverts ps = match ps with
        | p1::p2::p ->
            let vs = [upv * height; p1;p2]
            vs::makeverts (p2::p)
        | _ -> []
    makeverts circ
