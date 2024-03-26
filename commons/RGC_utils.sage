########################
# Funciones auxiliares #
########################

# calcula la distancia entre dos vectores
# - d1: vector 1
# - d2: vector 2
#
def distancia(d1, d2):
    v = [];
    for i in range(min(len(d1), len(d2))):
        v.append(abs(d1[i] - d2[i]));

    return sum(v);


#
#
#
def degreeSequenceToDegreeHistogram(d):
    h = zero_vector(max(d)+1);
    
    for v in d:
        h[v] = h[v]+1;
        
    return list(h);

# Calcula el procentaje de interseccion de aristas entre dos grafos
# - g1: grafo 1
# - g2: grafo 2
#
def edge_intersection(g1, g2):
    
    edges1 = g1.edges();
    edges2 = g2.edges();

    # calcular interseccion
    g1Ug2 = max(len(edges1), len(edges2));
    g1Ig2 = 0;
    for v in edges1:
        if v in edges2:
            g1Ig2 += 1;

    g1Ig2_percen = round((g1Ig2/g1Ug2)*100, 2);

    logging.info("edge_intersection: Conjuntos: [1="+str(len(edges1))+"] y [2="+str(len(edges2))+"]");
    logging.info("edge_intersection: Interseccion g1 y g2 = "+str(g1Ig2)+"/"+str(g1Ug2)+" ["+str(g1Ig2_percen)+"%]");
    
    print("edge_intersection: Conjuntos: [1="+str(len(edges1))+"] y [2="+str(len(edges2))+"]");
    print("edge_intersection: Interseccion g1 y g2 = "+str(g1Ig2)+"/"+str(g1Ug2)+" ["+str(g1Ig2_percen)+"%]");

    return g1Ig2_percen;
