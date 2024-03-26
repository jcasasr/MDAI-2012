load("../commons/import_functions.sage");
load("../commons/utils_datetime.sage");
load("../commons/utils_matrix.sage");


## aplica Random Switch
## - g: grafo
## - indice: % de perturbation aplicado
##
#def random_switch(g_original, indice):
#    # params
#    debug = false;
#
#    # numero de modificaciones
#    num_modificaciones = round(g.num_edges() * indice);
#    edges_modified = 0;
#
#    # modificar m aristas
#    while edges_modified < num_modificaciones:
#        # seleccionar dos aristas (no iguales) aleatoriamente
#        e1 = g.random_edge();
#        e2 = g.random_edge();
#
#        while e1 == e2:
#            e2 = g.random_edge();
#
#        # verificar que las aritas cruzadas no existan
#        new_e1 = (e1[0], e2[0], e1[2]);
#        new_e2 = (e1[1], e2[1], e2[2]);
#        if not(g.has_edge(new_e1) or g.has_edge(new_e2) or edge_is_loop(new_e1) or edge_is_loop(new_e2)):
#            g.add_edge(new_e1);
#            g.add_edge(new_e2);
#
#            g.delete_edge(e1);
#            g.delete_edge(e2);
#
#            edges_modified += 1;
#
#            # debug
#            if debug:
#                print("[debug]::random_switch: "+ str(e1) +" / "+ str(e2) +" --> "+ str(new_e1) +" / "+ str(new_e2));
#
#    # comprovacion
#    if G_original.num_edges() != g.num_edges():
#        print("[warning]::random_switch: Numero de aristas DIFERENTE: G_original="+str(G_original.num_edges())+" / g="+str(g.num_edges()));
#
#    return g;
#
#
## indica si una arista es un bucle (loop)
## - e: arista
##
#def edge_is_loop(e):
#    if e[0] == e[1]:
#        return true;
#
#    return false;


# aplica Random Switch
# - g: grafo
# - indice: % de perturbation aplicado
#
def random_switch_am(g_original, indice):
    # params
    debug = false;
    
    # numero de modificaciones
    num_modificaciones = round(g_original.num_edges() * indice);
    edges_modified = 0;
    
    # matrix de adyacencia
    A = g_original.adjacency_matrix();
    num_nodes = A.nrows();

    # debug
    if debug:
        print("[debug] Numero de modificaciones = "+ str(num_modificaciones));

    # modificar m aristas
    while edges_modified < num_modificaciones:
        # seleccionar dos aristas (no iguales) aleatoriamente
        (a,b) = find_value_in_matrix(A,1);
        (c,d) = find_value_in_matrix(A,1);

        while (a==b):
            (a,b) = find_value_in_matrix(A,1);
        
        while (a==c or a==d or b==c or b==d or c==d):
            (c,d) = find_value_in_matrix(A,1);

        # verificar que las aritas cruzadas no existan
        
        # opcion 1
        old_e1 = (a,b);
        old_e1_sim = (b,a);
        old_e2 = (c,d);
        old_e2_sim = (d,c);
        new_e1 = (a,c);
        new_e1_sim = (c,a);
        new_e2 = (b,d);
        new_e2_sim = (d,b);
        if (A[new_e1]==0 and A[new_e2]==0):
            # eliminar aristas viejas
            A[old_e1]=0;
            A[old_e1_sim]=0;
            A[old_e2]=0;
            A[old_e2_sim]=0;
            # insertar nuevas aristas
            A[new_e1]=1;
            A[new_e1_sim]=1;
            A[new_e2]=1;
            A[new_e2_sim]=1;

            edges_modified += 1;

            # debug
            if debug:
                print("[debug]::random_switch: A["+ str((a,b))+"] / A["+ str((c,d))+"] --> A["+ str(new_e1) +"] / A["+ str(new_e2))+"]";

    # crear el nuevo grafo a partir de la matriz de adyacencia
    g = create_from_AdjacencyMatrix(A);

    # comprovacion
    if G_original.num_edges() != g.num_edges():
        logging.warning("random_switch: Numero de aristas DIFERENTE: G_original="+str(G_original.num_edges())+" / g="+str(g.num_edges()));

    return g;


# construye un conjunto de grafos perturbados segun el modelo Random Switch de forma incremental
# - g_original: grafo original
# - num: numero de iteraciones
# - inc: incremento de la perturbacion en cada iteracion
#
def random_switch_set(g_original, num, inc):
    # crear grafo G_randSwitch
    g_set = [];

    for i in range(num):
        # initial time
        time_ini = time.time();
        
        if i == 0:
            g_set.append(random_switch_am(g_original, inc));
        if i > 0:
            g_set.append(random_switch_am(g_set[i-1], inc));

        # final time
        timestr = timestamp_to_string(time.time()-time_ini);
    
    return g_set;
