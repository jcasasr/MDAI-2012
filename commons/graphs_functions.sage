###
# GRAPH RELATED FUNCTIONS
###

# crea un grafo aleatorio
# - num_nodos: numero de nodos
# - pro_arista: probabilidad de aparicion de cada arista
# - peso_min: peso minimo de las aristas
# - peso_max: peso maximo de las aristas
#
def create_random_graph(num_nodos, prob_arista, peso_min, peso_max):
	
    logging.debug("Create random graph");
    # crear random graph
    g = graphs.RandomGNP(num_nodos, prob_arista);

    # crear etiquetas de los vertices
    for	e in g.edges():
        g.set_edge_label(e[0], e[1], randint(peso_min, peso_max))

    # informar
    g.allow_loops(False)
    g.allow_multiple_edges(False)
    g.weighted(True)

    logging.info("[DONE]Create random graph");

    return g;

# crea un grafo	aleatorio a	partir de una sequencia	de grados dada
# - sequence: secuencia	de grados
# - peso_min: peso minimo de las aristas
# - peso_max: peso maximo de las aristas
#
def create_random_graph_degree_sequence(sequence, peso_min, peso_max):
    # crear el grafo a partir de la secuencia de grados
    g = graphs.DegreeSequence(sequence);

    # crear etiquetas de los vertices
    for e in g.edges():
        g.set_edge_label(e[0], e[1], randint(peso_min, peso_max));

    # informar
    g.allow_loops(False);
    g.allow_multiple_edges(False);
    g.weighted(True);

    return g;

def compare_graphs(g1, g2):
    g2_edges = g2.edges();

    i = 0;
    total = 0;
    for e in g1.edges():
        if g2_edges.count(e) == 0:
            print("- node "+ str(i) +": "+ str(e));
            total = total+1;
        i = i+1;

    print("TOTAL: "+ str(total));

# Calcula el procentaje de interseccion de aristas entre dos grafos
# - g1: grafo 1
# - g2: grafo 2
#
def edge_intersection(g1, g2):
    edges1 = g1.edges();
    edges2 = g2.edges();

    # calcular interseccion
    g1Ig2 = 0;
    for v in edges1:
        if v in edges2:
            g1Ig2 += 1;

    return g1Ig2;

def edge_intersection_am(g1, g2):
	A1 = g1.adjacency_matrix();
	A2 = g2.adjacency_matrix();
	
	# calcular interseccion
	g1Ig2 = 0;
	for i in range(A1.nrows()-1):
		for j in range(A1.ncols()-1):
			if(A1[i,j]==1 and A2[i,j]==1):
				g1Ig2 += 1;
	
	return g1Ig2;

# contabiliza el numero de aristas diferentes entre dos grafos
# - g1: grafo 1
# - g2: grafo 2
#
def get_num_different_edges(g1, g2):
    dif = 0;
    
    for e in g1.edges():
        if not(g2.has_edge(e)):
            dif += 1;

    return dif;
