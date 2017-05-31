#############################################################################
##
##                                NautyInterface package
##
##  Copyright 2017, Sebastian Gutsche, Universität Siegen
##                  Alice Niemeyer,    RWTH Aachen
##                  Pascal Schweitzer, RWTH Aachen
##
#############################################################################

DeclareRepresentation( "IsNautyGraphRep",
                       IsNautyGraph and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "TheFamilyOfNautyGraphs",
        NewFamily( "TheFamilyOfNautyGraphs" ) );

BindGlobal( "TheTypeOfNautyGraphs",
        NewType( TheFamilyOfNautyGraphs,
                IsNautyGraphRep ) );

DeclareRepresentation( "IsNautyEdgeColoredGraphRep",
                       IsNautyGraph and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "TheTypeOfNautyEdgeColoredGraphs",
        NewType( TheFamilyOfNautyGraphs,
                IsNautyEdgeColoredGraphRep ) );

InstallGlobalFunction( CREATE_NAUTY_GRAPH_OBJECT,
  function( record )
    local edges, colors;
    
    edges := record.edges;
    edges := NautyGraphFromEdges( edges );
    record.edges_source := edges[ 1 ];
    record.edges_range := edges[ 2 ];
    
    if IsBound( record.colors ) then
        colors := record.colors;
        colors := NautyColorData( colors );
        record.color_labels := colors[ 1 ];
        record.color_partition := colors[ 2 ];
    fi;
    
    ObjectifyWithAttributes( record, TheTypeOfNautyGraphs,
                             IsDirected, record.directed,
                             IsColored, IsBound( record.colors ) );
    
    return record;
    
end );

InstallGlobalFunction( CREATE_NAUTY_EDGE_COLORED_GRAPH,
  function( record )
    
    ObjectifyWithAttributes( record, TheTypeOfNautyEdgeColoredGraphs,
                             IsDirected, record.directed );
    
    return record;
    
end );

InstallMethod( NautyGraph,
               [ IsList ],
               
  function( edges )
    local nr_nodes;
    
    nr_nodes := MaximumList( Flat( edges ) );
    
    return NautyGraph( edges, nr_nodes );
    
end );

InstallMethod( NautyGraph,
               [ IsList, IsInt ],
               
  function( edges, nr_nodes )
    local graph_rec;
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := false );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyDiGraph,
               [ IsList ],
               
  function( edges )
    local nr_nodes;
    
    nr_nodes := MaximumList( Flat( edges ) );
    
    return NautyDiGraph( edges, nr_nodes );
    
end );

InstallMethod( NautyDiGraph,
               [ IsList, IsInt ],
               
  function( edges, nr_nodes )
    local graph_rec;
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := true );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyColoredGraph,
               [ IsList, IsList ],
               
  function( edges, colors )
    local graph_rec, nr_nodes;
    
    nr_nodes := Length( colors );
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := false,
                      colors := colors );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyColoredDiGraph,
               [ IsList, IsList ],
               
  function( edges, colors )
    local graph_rec, nr_nodes;
    
    nr_nodes := Length( colors );
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := true,
                      colors := colors );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyEdgeColoredGraph,
               [ IsList ],
               
  function( edges )
    local nr_nodes;
    
    nr_nodes := MaximumList( Flat( edges ) );
    
    return NautyEdgeColoredGraph( edges, nr_nodes );
    
end );

InstallMethod( NautyEdgeColoredGraph,
               [ IsList, IsInt ],
               
  function( edges, nr_nodes )
    local graph_rec;
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edge_list := edges,
                      directed := false );
    
    return CREATE_NAUTY_EDGE_COLORED_GRAPH( graph_rec );
    
end );

InstallMethod( ViewObj,
               [ IsNautyGraph and IsDirected ],
               
  function( graph )
    
    Print( "<A directed Nauty graph>" );
    
end );

InstallMethod( ViewObj,
               [ IsNautyGraph ],
               
  function( graph )
    
    Print( "<A Nauty graph>" );
    
end );

InstallGlobalFunction( CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES,
  
  function( nauty_graph )
    local colors, nauty_data, automorphism_group;
    
    if IsNautyEdgeColoredGraphRep( nauty_graph ) then
        CALL_NAUTY_ON_EDGE_COLORED_GRAPH( nauty_graph );
        return;
    fi;
    
    if IsColored( nauty_graph ) then
        colors := [ nauty_graph!.color_labels, nauty_graph!.color_partition ];
    else
        colors := false;
    fi;
    
    nauty_data := NautyDense( nauty_graph!.edges_source, 
                              nauty_graph!.edges_range,
                              nauty_graph!.nr_nodes,
                              IsDirected( nauty_graph ),
                              colors );
    
    if nauty_data[ 1 ] <> [ ] then
        SetAutomorphismGroup( nauty_graph, Group( nauty_data[ 1 ] ) );
    else
        SetAutomorphismGroup( nauty_graph, Group( () ) );
    fi;
    SetAutomorphismGroupGenerators( nauty_graph, nauty_data[ 1 ] );
    SetCanonicalLabeling( nauty_graph, nauty_data[ 2 ] );
    
end );

InstallGlobalFunction( CALL_NAUTY_ON_EDGE_COLORED_GRAPH,
  
  function( nauty_graph )
    local nr_nodes, nauty_data, edge_data, color_data;
    
    nr_nodes := nauty_graph!.nr_nodes;
    
    nauty_data := NautyGraphDataForColoredEdges( nauty_graph!.edge_list, nr_nodes, false );
    
    edge_data := NautyGraphFromEdges( nauty_data[ 1 ] );
    
    color_data := NautyColorData( nauty_data[ 2 ] );
    
    nauty_data := NautyDense( edge_data[ 1 ], edge_data[ 2 ], Length( nauty_data[ 2 ] ), IsDirected( nauty_graph ), color_data );
    
    nauty_data[ 1 ] := List( nauty_data[ 1 ], i -> Permutation( i, [ 1 .. nr_nodes ] ) );
    nauty_data[ 2 ] := Permutation( nauty_data[ 2 ], [ 1 .. nr_nodes ] );
    
    if nauty_data[ 1 ] <> [ ] then
        SetAutomorphismGroup( nauty_graph, Group( nauty_data[ 1 ] ) );
    else
        SetAutomorphismGroup( nauty_graph, Group( () ) );
    fi;
    SetAutomorphismGroupGenerators( nauty_graph, nauty_data[ 1 ] );
    SetCanonicalLabeling( nauty_graph, nauty_data[ 2 ] );
    
end );

InstallMethod( AutomorphismGroup,
               [ IsNautyGraph ],
               
  function( graph )
    
    CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES( graph );
    
    return AutomorphismGroup( graph );
    
end );

InstallMethod( AutomorphismGroupGenerators,
               [ IsNautyGraph ],
               
  function( graph )
    
    CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES( graph );
    
    return AutomorphismGroupGenerators( graph );
    
end );

InstallMethod( CanonicalLabeling,
               [ IsNautyGraph ],
               
  function( graph )
    
    CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES( graph );
    
    return CanonicalLabeling( graph );
    
end );