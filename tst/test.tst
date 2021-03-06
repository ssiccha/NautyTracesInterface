gap> Petersen := Graph( SymmetricGroup(5), [[1,2]], OnSets,
>                   function(x,y) return Intersection(x,y)=[]; end );
rec( adjacencies := [ [ 3, 5, 8 ] ], 
  group := Group([ (1,2,3,5,7)(4,6,8,9,10), (2,4)(6,9)(7,10) ]), 
  isGraph := true, 
  names := [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 3 ], [ 4, 5 ], [ 2, 4 ], 
      [ 1, 5 ], [ 3, 5 ], [ 1, 4 ], [ 2, 5 ] ], order := 10, 
  representatives := [ 1 ], schreierVector := [ -1, 1, 1, 2, 1, 1, 1, 1, 2, 2 
     ] )
gap> Petersen := Digraph( Petersen );;
gap> edg := DigraphEdges( Petersen );
[ [ 1, 3 ], [ 1, 5 ], [ 1, 8 ], [ 2, 5 ], [ 2, 7 ], [ 2, 9 ], [ 3, 1 ], 
  [ 3, 7 ], [ 3, 10 ], [ 4, 5 ], [ 4, 6 ], [ 4, 10 ], [ 5, 1 ], [ 5, 2 ], 
  [ 5, 4 ], [ 6, 4 ], [ 6, 7 ], [ 6, 8 ], [ 7, 2 ], [ 7, 3 ], [ 7, 6 ], 
  [ 8, 1 ], [ 8, 6 ], [ 8, 9 ], [ 9, 2 ], [ 9, 8 ], [ 9, 10 ], [ 10, 3 ], 
  [ 10, 4 ], [ 10, 9 ] ]
gap> pet_nauty := NautyGraphFromEdges( edg );
[ [ 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 
      9, 9, 9, 10, 10, 10 ], 
  [ 3, 5, 8, 5, 7, 9, 1, 7, 10, 5, 6, 10, 1, 2, 4, 4, 7, 8, 2, 3, 6, 1, 6, 9, 
      2, 8, 10, 3, 4, 9 ] ]
gap> pet_source := pet_nauty[ 1 ];
[ 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 
  9, 9, 10, 10, 10 ]
gap> pet_range := pet_nauty[ 2 ];
[ 3, 5, 8, 5, 7, 9, 1, 7, 10, 5, 6, 10, 1, 2, 4, 4, 7, 8, 2, 3, 6, 1, 6, 9, 
  2, 8, 10, 3, 4, 9 ]
gap> NautyDense( pet_source, pet_range, 10, false, false );
[ [ (2,4)(6,9)(7,10), (2,6)(4,9)(5,8), (2,6,10)(3,5,8)(4,9,7), 
      (1,2,3,5,7)(4,6,8,9,10) ], (2,3,5,7)(4,8,9,6,10) ]
