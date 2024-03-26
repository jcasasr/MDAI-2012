load("../commons/import_functions.sage");
load("../commons/utils_datetime.sage");
load("../commons/utils_matrix.sage");

# aplica Random Perturbation
# - g: grafo
# - indice: % de perturbation aplicado
# - peso_min: peso minimo de las nuevas aristas
# - peso_max: peso maximo de las nuevas aristas
#
#def random_perturbation(g_original, indice, peso_min, peso_max):
#    # crear copia y modificar
#    g = copy(g_original);
#
#    # comprovar si G tiene pesos en las aristas
#    pesos_aristas = False;
#    if g.edges()[0][2] != {}:
#        pesos_aristas = True;
#
#    # numero de modificaciones
#    num_modificaciones = round(g.num_edges() * indice) * 2;
#
#    # selecciona m aristas para eliminar
#    edges_to_delete = [];
#    print("********************************************");
#    asd = g.num_edges() - 1;
#    while len(edges_to_delete) < num_modificaciones:
#        #e_candidate = g.random_edge();
#        qwe = randint(0, asd);
#        print(str(qwe)+"/"+str(g.num_edges()));
#        e_candidate = g.edges()[qwe];
#        if edges_to_delete.count(e_candidate) == 0:
#            edges_to_delete.append(e_candidate);
#
#    # add m aristas
#    while g.num_edges() < g_original.num_edges() + num_modificaciones:
#        peso = {};
#        if pesos_aristas == True:
#            peso = randint(peso_min, peso_max);
#
#        g.add_edge(g.random_vertex(), g.random_vertex(), peso);
#
#    # eliminar las m aristas seleccionadas en el paso anterior
#    for e in edges_to_delete:
#        g.delete_edge(e);
#
#    return g;
#
## aplica Random Perturbation
## - g: grafo
## - indice: % de perturbation aplicado
##
#def random_perturbation(g_original, indice):
#    # crear copia y modificar
#    g = copy(g_original);
#
#    # numero de modificaciones
#    num_edges = g_original.num_edges();
#    num_modificaciones = round(num_edges * indice * 2, 0);
#
#    # delete m edges
#    while g.num_edges() > (num_edges - num_modificaciones):
#        g.delete_edge(g.random_edge());
#
#    # add m edges
#    while g.num_edges() < num_edges:
#        new_e = (g.random_vertex(), g.random_vertex(), {});
#        if not(g.has_edge(new_e)):
#            g.add_edge(new_e);
#
#    return g;


# aplica Random Perturbation
# - g: grafo
# - indice: % de perturbation aplicado
#
def random_perturbation_am(g_original, indice):
    # numero de modificaciones
    num_edges = g_original.num_edges();
    num_modificaciones = round(num_edges * indice * 2, 0);
    
    # matrix de adyacencia
    A = g_original.adjacency_matrix();
    num_nodes = A.nrows();

    # delete m edges
    num_eliminaciones = 0;
    while num_eliminaciones < num_modificaciones:
        (i,j) = find_value_in_matrix(A,1);
        if A[i,j]==1:
            A[i,j]=0;
            A[j,i]=0;
            num_eliminaciones = num_eliminaciones+1;

    # add m edges
    num_adiciones = 0;
    while num_adiciones < num_modificaciones:
        (i,j) = find_value_in_matrix(A,0);
        if A[i,j]==0 and i!=j:
            A[i,j]=1;
            A[j,i]=1;
            num_adiciones = num_adiciones+1;
    
    # crear el nuevo grafo a partir de la matriz de adyacencia
    g = create_from_AdjacencyMatrix(A);

    return g;


# construye un conjunto de grafos perturbados segun el modelo Random Perturbation de forma incremental
# - g_original: grafo original
# - num: numero de iteraciones
# - inc: incremento de la perturbacion en cada iteracion
#
def random_perturbation_set(g_original, num, inc):
    # crear grafo G_randPertur
    g_set = [];

    for i in range(num):
        # initial time
        time_ini = time.time();

        if i == 0:
            g_set.append(random_perturbation_am(g_original, inc));
        if i > 0:
            g_set.append(random_perturbation_am(g_set[i-1], inc));
        
        # final time
        timestr = timestamp_to_string(time.time()-time_ini);

    return g_set;
