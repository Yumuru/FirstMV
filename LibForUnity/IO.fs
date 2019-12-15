module IO

[<Struct>]
type IO<'t> = IO of (unit -> 't)

let iorun (IO x) = x ()
let iocons v = IO (fun () -> v)

type IO<'t> with
    static member Return x = IO (fun () -> x)
    static member (>>=) (IO x, f:'T -> IO<'U>) = IO (fun () -> iorun <| f(x ()))
    static member (<*>) (f:IO<'T->'U>, x:IO<'T>) = IO (fun () -> iorun f (iorun x))
