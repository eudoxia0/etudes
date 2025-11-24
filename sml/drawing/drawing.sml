structure PS = struct
  fun toFile filepath str =
    let val stream = TextIO.openOut filepath
    in
        TextIO.output (stream, str) handle e => (TextIO.closeOut stream; raise e);
        TextIO.closeOut stream
    end
end

structure R2 = struct
  type pt = int

  datatype point = Point of pt * pt

  fun px (Point (x, _)) = x
  fun py (Point (_, y)) = y

  datatype line = Line of point * point

  fun draw (Line (Point (x0, y0), Point (x1, y1))) =
    let fun coords x y = (Int.toString x) ^ " " ^ (Int.toString y)
        and moveto x y = (coords x y) ^ " moveto"
        and lineto x y = (coords x y) ^ " lineto stroke "
    in
        (moveto x0 y0) ^ "\n" ^ (lineto x1 y1)
    end

  fun square (Point (x0, y0)) (Point (x1, y1)) =
    let val upleft = Point (x0, y1)
        and upright = Point (x1, y1)
        and downright = Point (x1, y0)
        and downleft = Point (x0, y0)
    in
        [
          Line (upleft, upright),
          Line (upright, downright),
          Line (downright, downleft),
          Line (downleft, upleft)
        ]
    end

  fun drawall lines file = PS.toFile file (foldl (fn (a,b) => a ^ "\n" ^ b) "" (map draw lines))
end;

structure R3 = struct
  type pt = int

  datatype point = Point of pt * pt * pt

  datatype line = Line of point * point

  fun cube (Point (x0, y0, z0)) (Point (x1, y1, z1)) =
    let val b1 = Point (x0, y0, z0)
        and b2 = Point (x0, y1, z0)
        and b3 = Point (x1, y1, z0)
        and b4 = Point (x1, y0, z0)
        and t1 = Point (x0, y0, z1)
        and t2 = Point (x0, y1, z1)
        and t3 = Point (x1, y1, z1)
        and t4 = Point (x1, y0, z1)
    in
        [
          (* Bottom *)
          Line (b1, b2),
          Line (b2, b3),
          Line (b3, b4),
          Line (b4, b1),
          (* Middle *)
          Line (b1, t1),
          Line (b2, t2),
          Line (b3, t3),
          Line (b4, t4),
          (* Top *)
          Line (t1, t2),
          Line (t2, t3),
          Line (t3, t4),
          Line (t4, t1)
        ]
    end

  fun project (Point (ex, ey, ez)) (Point (x, y, z)) =
    R2.Point (((x * ez) - (z * ex)) div (ez - z),
              ((y * ez) - (z * ey)) div (ez - z))

  fun projectLine eye (Line (p1, p2)) =
    R2.Line (project eye p1, project eye p2)

  fun drawall eye lines file = R2.drawall (map (projectLine eye) lines) file

end;

R2.drawall (R2.square (R2.Point (100,100)) (R2.Point (300, 300))) "2d.ps";

R3.drawall (R3.Point (50,50,~100))
           (R3.cube (R3.Point (0,0,0)) (R3.Point (100, 100, 100)))
           "3d.ps";
