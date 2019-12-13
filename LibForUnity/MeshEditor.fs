module MeshEditor

open UnityEngine
open FSharpPlus

type Polygon = {
        vertices : Vector3 list
        triangles : int list
        uv : Vector2 list
    }
type Vertex = {
        vertex : Vector3
        uv : Vector2
    }

let setv3x (v:Vector3) x = Vector3(x, v.y, v.z)
let setv3y (v:Vector3) y = Vector3(v.x, y, v.z)
let setv3z (v:Vector3) z = Vector3(v.x, v.y, z)

let makerange b f n = [b..f b n]
let transvalue rate n = List.map (rate n) <| [0.f..n-1.f]

let ratef0 mn n = n / mn
let ratef0t1 mn n = n / mn-1.f

let transvalf0t1 = transvalue ratef0t1
let transvalf0 = transvalue ratef0

let fvec2 f = Vector2(f(), f())
let fvec3 f = Vector3(f(), f(), f())
let random () = Random.value
let randomV2 scale () =
    let rand () = random () - 0.5f
    Vector2.Scale(fvec2 rand, scale)
let randomV3 scale () = 
    let rand () = random () - 0.5f
    Vector3.Scale(fvec3 rand, scale)

let polyverts c =
    let rot = Quaternion.AngleAxis(60.f, Vector3.up)
    let d = Vector3.forward * 0.001f
    [c + d; c + rot * d; c + rot * rot * d]

let value2uv vs =
    let ls1::ls2::ls3::ls4::ls5::ls6::_ = vs @ List.init 6 (fun _ -> [0.f]) 
    monad {
        let! v1 = ls1
        let! v2 = ls2
        let! v3 = ls3
        let! v4 = ls4
        let! v5 = ls5
        let! v6 = ls6
        return [
            new Vector2(v1, v2)
            new Vector2(v3, v4)
            new Vector2(v5, v6)
        ]
    }

let rand scale vs () = 
    let uvs = value2uv vs
    let polys =
        let ran = randomV3 scale
        let poly uv = 
            let center = ran ()
            let vs = polyverts center
            List.map2 (fun v u -> { vertex = v; uv = u }) vs uv
        List.map poly uvs
    let vertexes = List.concat polys
    let vertices = List.map (fun v -> v.vertex) vertexes
    let triangles = List.mapi (fun i _ -> i) vertexes
    let uv = List.map (fun v -> v.uv) vertexes
    { vertices = vertices; triangles = triangles; uv = uv }
