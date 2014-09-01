open React

module Mouse = 
   struct
     let position, set_position = S.create (0, 0)
   end

let canvas = 
  Js.Opt.get (Js.Opt.bind 
		(Dom_html.window##document##getElementById (Js.string "1")) 
		Dom_html.CoerceTo.canvas) 
    (fun () -> raise (Invalid_argument "No canvas with id 1."))

let ctx = canvas##getContext (Dom_html._2d_)

let pi = 4. *. atan 1.

type circle = {x : float; y : float; radius : float; color : string}

let circles, circles_s =
  [
    {x = 250.; y = 80.; radius = 60.; color = "#33cc33"};
    {x = 100.; y = 260.; radius = 60.; color = "#19a3a3"};
    {x = 400.; y = 260.; radius = 60.; color = "#e64848"}
  ],
  [
    S.create "#000";
    S.create "#000";
    S.create "#000"
  ]

let in_circle x y c =
  sqrt (((c.x -. x) ** 2.) +. ((c.y -. y) ** 2.)) <= c.radius

let mouse_on_canvas (x, y) =
  let rect = canvas##getBoundingClientRect () in
  let color = 
    (try
      (List.find (in_circle ((float_of_int x) -. rect##left) ((float_of_int y) -. rect##top)) circles).color
    with Not_found -> "#000")
  in List.iter (fun (_, f) -> f ?step:None color) circles_s

let draw_circle (ctx : Dom_html.canvasRenderingContext2D Js.t) c color =
  ctx##beginPath ();
  ctx##arc (c.x, c.y, c.radius, 0., 2. *. pi, Js._false);
  ctx##fillStyle <- (Js.string c.color);
  ctx##fill ();
  ctx##lineWidth <- 20.;
  ctx##strokeStyle <- (Js.string color);
  ctx##stroke ()

let _ =
  List.iter2 (fun c (s, _) -> ignore (S.map (draw_circle ctx c) s)) circles circles_s;
  Dom_html.window##onmousemove <- (Dom_html.handler 
				     (fun e -> Mouse.set_position (e##clientX, e##clientY); Js._true));
  S.map mouse_on_canvas Mouse.position
  
