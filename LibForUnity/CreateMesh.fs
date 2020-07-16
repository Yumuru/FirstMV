module CreateMesh

open UnityEngine
open FSharpPlus
open MeshEditor
open IO

let randPoly [(v1x, v1y); (v2x, v2y); (v3x, v3y)] scale = 
    let uvs = monad {
        let! v1 = transvalf0 <| v1x
        let! v2 = transvalf0 <| v1y
        let! v3 = transvalf0 <| v2x
        let! v4 = transvalf0 <| v2y
        let! v5 = [0.f..float32 v3x - 1.f]
        let! v6 = [0.f..float32 v3y - 1.f]
        return map tup2vec2 [(v1, v2); (v3, v4); (v5, v6)]
    }
    let makepoly uv = iorun <| monad {
        let! randp = randomV3
        let pos = Vector3.Scale(scale, randp)
        let vs = map ((+) pos) pointpolyv
        return polygon vs [] uv
    }
    map makepoly uvs

let firstMelogyObj width num scale = 
    let genCube v u =
        let uv = map tup2vec2 [(0.f, u); (0.f, 0.f); (0.f, 0.f)]
        let ncube = List.map (List.map ((+) v << (*) width)) cube
        List.map (fun vs -> polygon vs [] uv) ncube
    let points = [
        Vector3.right * width
        Vector3.left * width
        Vector3.up * width
        Vector3.down * width
        Vector3.forward * width
        Vector3.back * width
    ]
    let uvit = map float32 [0; 1; 2; 3; 4; 5]
    let cubes = List.concat <| List.map2 genCube points uvit
    let makecubes us = monad {
        let uvup = List.map updatevec2 us
        let! randv = randomV3
        let pupdate p = 
            let nuv = List.map2 (<|) uvup (puvs p)
            let addv = (+) <| Vector3.Scale(randv, scale)
            let center = addv Vector3.zero
            let nvs = List.map addv <| vertices p
            polygon nvs [center;center;center] nuv
        List.map pupdate cubes
    }
    let uvs  = monad {
        let! v = [0.f..num-1.f]
        return [((fun _ -> v / num), id); (id, id); (id, id)]
    }
    List.map makecubes uvs
        |> sequence : IO<Polygon list list>
        |>> List.concat

let box scale = 
    let trans v = Vector3.Scale(scale, v)
    let pverts = List.map (List.map trans) cube
    let makepoly vs = polygon vs [] [Vector2.zero; Vector2.zero; Vector2.zero]
    List.map makepoly pverts

let randomlaser num width scale =
    let btube = tube 8.f Vector3.up (Vector3.forward*width) 1000.f
    let addtube v = List.map (List.map ((+) v)) btube
    let maketube us = iorun <| monad {
        let! rand = randomV3
        let randv = Vector3.Scale(rand, scale)
        let vs = Vector3.Scale(randv, Vector3(1.f, 0.f, 1.f))
                    |> addtube
        let genpoly v = polygon v [] us
        return List.map genpoly vs
    } 
    let makeuv i = [(i/num, 0.f); (0.f, 0.f); (0.f, 0.f)]
    let uvs = List.map makeuv [0.f..num-1.f]
    List.map maketube <| List.map (List.map tup2vec2) uvs
        |> List.concat

let hexobjs height blength bwidthx bwidthy radius =
    let makecone up = List.map (List.map ((+) <| up * 0.3f)) <| cone 4.f up Vector3.forward height
    let cones = List.map makecone [Vector3.up; Vector3.down]
    let board = 
        let pos = Vector3.back *1.f
        let center = pos + Vector3.back * blength
        let (x, y) = (Vector3.right*bwidthx, Vector3.up * bwidthy)
        let points = [| center-x/2.f-y/2.f; center-x/2.f+y/2.f; center+x/2.f+y/2.f; center+x/2.f-y/2.f |]
        let vs1 = List.map List.rev [
            [pos; points.[0]; points.[1]]
            [pos; points.[1]; points.[2]]
            [pos; points.[2]; points.[3]]
            [pos; points.[3]; points.[0]] ]
        let vs2 = [
            [points.[0]; points.[1]; points.[3]]
            [points.[2]; points.[3]; points.[1]] ]
        vs1 @ vs2
    let mobj = 
        let mcones =
            let makecone vs us = List.map (fun v -> polygon v [] us) vs
            let makeuv uval = List.map tup2vec2 [(1.f, uval); (0.f, 0.f); (0.f, 0.f)]
            let uvs = List.map makeuv [0.f;1.f] 
            List.map2 makecone cones uvs
        let mcube = 
            let uv = List.map tup2vec2 [(0.f, 0.f);(0.f, 0.f);(0.f, 0.f)]
            List.map (fun v -> polygon v [] uv) cube
        let mboards =
            let makeuv uval = List.map tup2vec2 [(2.f, uval); (0.f, 0.f); (0.f, 0.f)]
            let rotate i v = Quaternion.AngleAxis(360.f / 4.f * i, Vector3.up) * v 
            let trans i v = rotate i <| v + Vector3.back * 0.3f
            let makeboard rot = List.map (List.map rot) board
            let boards = List.map makeboard <| List.map trans [0.f..3.f]
            let uvs = List.map makeuv [0.f..3.f]
            let makeboards vs us = List.map (fun v -> polygon v [] us) vs
            List.map2 makeboards boards uvs
        mcube @ (List.concat <| mcones @ mboards)
        List.concat <| mcones @ mboards
    let circ =
        let rotate v = Quaternion.AngleAxis(60.f, Vector3.up) * v * radius
        List.map rotate <| circleps 6.f Vector3.up Vector3.forward
    let objs = 
        let mob v = 
            let updatep p = 
                let vs = vertices p
                polygon (List.map ((+) v) vs) (normals p) (puvs p)
            List.map updatep mobj
        List.map mob circ
    objs |> List.concat
            