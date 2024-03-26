##############################
# Relaxed Graph Construction #
##############################
# Implementacion del algoritmo 'Relaxed Graph Construction' descrito en:
#	Kun Liu and Evimaria Terzi.
#	Towards identity anonymization on graphs.
#	In Proceedings of the 2008 ACM SIGMOD international conference on Management of data, SIGMOD 08, pages 93106, New York, NY, USA, 2008. ACM.


# aplica Relaxed Graph Construction
# - g: grafo
# - k: grado de k-anonimidad
#
def RGC(g_original, k):
    # initial time
    time_ini = time.time();

    # obtener la secuencia de grados del grafo original
    d_original = g_original.degree_sequence();

    logging.info("RGC: Grafo original: "+str(g_original.num_verts())+" nodos y "+str(g_original.num_edges())+" aristas.");
    logging.info("RGC: Secuencia original: "+str(d_original));
    logging.info("RGC: Grado de k-anonimidad = "+str(kanonymity_value(d_original)));

    # anonimizar la secuencia de grados segun el valor de k
    d_anonimizada = ConstructGraphSequence(d_original, k);

    logging.info("RGC: Secuencia anonimizada: "+str(d_anonimizada));
    logging.info("RGC: Grado de k-anonimidad = "+str(kanonymity_value(d_anonimizada)));
    logging.info("RGC: Distancia a la secuencia original = "+str(distancia(d_anonimizada, d_original)));
    
    # final time
    timestr = timestamp_to_string(time.time()-time_ini);
    print("RGC: Total running time "+timestr);
    logging.info("RGC: Total running time "+timestr);

#    # Construir el grafo a partir de la secuencia de grados (d')
#    g0 = graphs.DegreeSequence(d_anonimizada);
#
#    logging.debug("RGC: Grafo reconstruido a partir de la secuencia anonimizada: "+str(g0.num_verts())+" nodos y "+str(g0.num_edges())+" aristas.");
#    edge_intersection(g0, g_original);
#
#    # aplicar Greedy Swap
#    g = Greedy_Swap(g0, g_original);
#
#    logging.debug("RGC: Grafo anonimizado: "+str(g.num_verts())+" nodos y "+str(g.num_edges())+" aristas.");
#    edge_intersection(g, g_original);
#
#    return g;


# Aplicar algoritmos geneticos para conseguir una secuencia que:
# 1) cumpla la restriccion de sum(d) == sum(d')
# 2) minimize la distancia (d - d')
#
def ConstructGraphSequence(original_d, k):
    # params
    poblacion_num = 50;
    descendientes_num = 50; # descendientes por cada individuo
    porcentaje_aleatorio = 0.5;
    max_iterations = 100;
    max_num_iteraciones_sin_mejora = 10;

    # crear individuo original
    #
    # Formato de cada individuo: [[degree_sequence], k, num, (d-d0)]
    # - k: valor actual de k-anonimidad
    # - num: numero de nodos que incumplen el valor deseado de k-anonimidad
    # - (d-do): distancia entre la secuencia original y la secuencia actual (se debe minimizar)
    #
    original_k = kanonymity_value(original_d);
    original_num = distancia_nodos_inclumpen_kanonymity(original_d, k);
    original_dist = 0;
    original_punt = puntuacion(k, original_k, original_num, original_dist);

    original = [original_d, original_k, original_num, original_dist, original_punt];

    # comprovacion
    if original_k >= k:
        logging.info("ConstructGraphSequence: La secuencia ya es "+ str(k) +"-anonima!");
        print("La secuencia ya es "+ str(k) +"-anonima!");
        return original[0];

    # debug
    logging.debug("ConstructGraphSequence: secuencia original k="+ str(original_k) +" --> objetivo k="+ str(k));

    # generar nueva poblacion inicial
    poblacion = [];

    for i in range(poblacion_num):
        poblacion.append(original);

    # bucle principal
    iteracion = 0;
    mejor_puntuacion = [];
    mejor_k = 0;
    no_mejora = false;

    while ((iteracion < max_iterations) and (no_mejora == false)) or (mejor_k < k):
        # debug
        logging.debug("ConstructGraphSequence: Iteracion *** "+ str(iteracion)+" ***");

        # inicializar los descendientes
        descendientes = [];

        # debug
        logging.debug("ConstructGraphSequence: Generando candidatos...");

        # generar descendientes a partir de la poblacion actual
        for i in range(poblacion_num):
            for j in range(descendientes_num):
                # generar candidato
                candidato_d = mutar(poblacion[i][0], k);
                candidato_k = kanonymity_value(candidato_d);
                candidato_num = distancia_nodos_inclumpen_kanonymity(candidato_d, k);
                candidato_dist = distancia(original_d, candidato_d);
                candidato_punt = puntuacion(k, candidato_k, candidato_num, candidato_dist);

                candidato = [candidato_d, candidato_k, candidato_num, candidato_dist, candidato_punt];

                # add
                if not(candidato in descendientes):
                    descendientes.append(candidato);

        # debug
        logging.debug("ConstructGraphSequence: Evaluando candidatos [poblacion = "+str(len(poblacion))+", descendientes = "+str(len(descendientes))+"]");

        # ordenadar los n mejores individuos
        todos = poblacion + descendientes;
        todos.sort(cmp=lambda x,y: cmp(x[4],y[4]), reverse=True);

        # debug
        logging.debug("ConstructGraphSequence: Seleccionando los mejores candidatos...");

        # seleccionar la siguiente generacion
        poblacion = [];

        # 50% - los mejores
        poblacion = todos[0:int(poblacion_num * (1 - porcentaje_aleatorio))];

        # 50% - aleatorio (para mantener la diversidad)
        while len(poblacion) < poblacion_num:
            poblacion.append(todos[randint(0,len(todos)-1)]);

        # debug
        for i in range(3):
            logging.debug("ConstructGraphSequence: Individuo "+str(i)+": "+str(poblacion[i]));

        # control de parada
        mejor_puntuacion.append(todos[0][4]);
        mejor_k = todos[0][1];

        if iteracion > max_num_iteraciones_sin_mejora:
            if mejor_puntuacion[iteracion - max_num_iteraciones_sin_mejora] >= mejor_puntuacion[iteracion]:
                no_mejora = true;
                # debug
                logging.debug("ConstructGraphSequence: No se han detectado mejoras en las ultimas "+str(max_num_iteraciones_sin_mejora)+" iteraciones!");
                logging.debug("ConstructGraphSequence: Parando ejecucion...");

        # iteraciones
        iteracion += 1;

    # seleccionar mejor individuo
    best_candidate = todos[0];

    #debug
    logging.info("ConstructGraphSequence: Anonimizacion de la secuencia a k="+str(k));
    logging.info("ConstructGraphSequence: Mejor individuo: "+ str(best_candidate));
    # print result
    print("ConstructGraphSequence: Anonimizacion de la secuencia a k="+str(k));
    print("ConstructGraphSequence: Mejor individuo: "+ str(best_candidate));
    print("");

    return best_candidate[0];


# aplica 1 mutacion a la secuencia dada, intentado que se aproxime a un valor superior de k
# - d_original: secuencia de grados
# - k: valor de k-anonimidad
#
def mutar(d_original, k):
    # debug
    debug = false;

    # vars
    d = copy(d_original);

    # buscar los nodos candidatos
    valor_medio = mean(d);
    index_max = len(d)-1;
    candidatos_add = [];
    candidatos_sub = [];

    for i in range(len(d)):
        if d.count(d[i]) < k:
            if d[i] > valor_medio:
                candidatos_sub.append(i);
            if d[i] <= valor_medio:
                candidatos_add.append(i);

    # debug
    #logging.debug("mutar: d="+ str(d));
    #logging.debug("mutar: candidatos_add="+ str(candidatos_add));
    #logging.debug("mutar: candidatos_sub="+ str(candidatos_sub));

    if len(candidatos_add) > 0 or len(candidatos_sub) > 0:
        # escoger los nodos a modificar entre los candidatos
        if len(candidatos_add) > 0:
            index_i = candidatos_add[randint(0,len(candidatos_add)-1)];
        if len(candidatos_add) == 0:
            index_i = randint(0,index_max);

        if len(candidatos_sub) > 0:
            index_j = candidatos_sub[randint(0,len(candidatos_sub)-1)];
        if len(candidatos_sub) == 0:
            index_j = randint(0,index_max);

        # si el nodo escogido para restar esta a 1, seleccionar otro
        while d[index_j] <= 1:
            index_j = randint(0,index_max)

        # debug
        #logging.debug("mutar: indices seleccionados: "+str(index_i)+"<--"+str(index_j));

        d[index_i] += 1;
        d[index_j] -= 1;

    return d;


# Aplica cambios en las aristas (sin modificar la secuencia de grados) para maximizar (G(E) Interseccion G_Original(E)
# - g: grafo a modificar
# - g_original: grafo original
#
def Greedy_Swap(_g, _g_original):
    # debug
    debug = false;

    # copiar los grafos originales
    g = copy(_g);
    g_original = copy(_g_original);

    # debug
    if debug:
        print("*** Original:");
        edge_intersection(g, g_original);

    # vars
    hay_cambios = true;
    iteracion = 0;

    while hay_cambios == true:
        hay_cambios = false;
        iteracion += 1;

        # debug
        if debug:
            print("[debug]::Greedy_Swap: Iteracion "+str(iteracion))

        aristas = g.edges();
        candidatos = [];

        for i in range(len(aristas)):
            for j in range(i+1, len(aristas)):
                del_e1 = aristas[i];
                del_e2 = aristas[j];

                if not(g_original.has_edge(del_e1)) and not(g_original.has_edge(del_e2)):
                    # opcion 1
                    add_e1 = (del_e1[0], del_e2[0], {});
                    add_e2 = (del_e1[1], del_e2[1], {});

                    if not(g.has_edge(add_e1)) and not(g.has_edge(add_e2)) and not(add_e1[0]==add_e1[1]) and not(add_e2[0]==add_e2[1]):
                        puntuacion = 0;
                        if g_original.has_edge(add_e1):
                            puntuacion += 1;
                        if g_original.has_edge(add_e2):
                            puntuacion += 1;

                        if puntuacion > 0:
                            candidatos.append([del_e1, del_e2, add_e1, add_e2, puntuacion]);

                    # opcion 2
                    add_e1 = (del_e1[0], del_e2[1], {});
                    add_e2 = (del_e1[1], del_e2[0], {});

                    if not(g.has_edge(add_e1)) and not(g.has_edge(add_e2)) and not(add_e1[0]==add_e1[1]) and not(add_e2[0]==add_e2[1]):
                        puntuacion = 0;
                        if g_original.has_edge(add_e1):
                            puntuacion += 1;
                        if g_original.has_edge(add_e2):
                            puntuacion += 1;

                        if puntuacion > 0:
                            candidatos.append([del_e1, del_e2, add_e1, add_e2, puntuacion]);

        # seleccionar el mejor
        if len(candidatos) > 0:
            candidatos.sort(cmp=lambda x,y: cmp(x[4],y[4]), reverse=True);
            candidato = candidatos[0];

            # debug
            if debug:
                print("[debug]::Greedy_Swap: Max swap: "+ str(candidato));

            del_e1 = candidato[0];
            del_e2 = candidato[1];
            add_e1 = candidato[2];
            add_e2 = candidato[3];

            # delete edges
            g.delete_edge(del_e1);
            g.delete_edge(del_e2);

            # add edges
            if g.has_edge(add_e1):
                print("[ERROR]::Greedy_Swap: La arista "+str(add_e1)+" ya existe!!");
            g.add_edge(add_e1);

            if g.has_edge(add_e2):
                print("[ERROR]::Greedy_Swap: La arista "+str(add_e2)+" ya existe!!")
            g.add_edge(add_e2);

            # debug
            if debug:
                edge_intersection(g, g_original);

            # iterar otra vez
            hay_cambios = true;

    return g;


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


# indica el valor de k-anonimidad
# - d: secuencia
#
def kanonymity_value(d):
    # set min value to max possible value
    k = max(d);

    # iterate to find min value
    for i in range(len(d)):
        if d.count(d[i]) < k:
            k = d.count(d[i]);

    return k;


# Indica el numero de nodos que estan incumpliendo la k-anonimidad para el valor k
# - d: secuencia de grados
# - k: valor deseado de k-anonimidad
#
#def num_nodos_inclumpen_kanonymity(d, k):
#	# var
#	num = 0;
#	
#	# iterate
#	for i in range(len(d)):
#		v = d.count(d[i]);
#		if v < k:
#			num += 1;
#	
#	return num;


# Indica el numero de nodos que estan incumpliendo la k-anonimidad para el valor k 
# i la distancia a la que se encuentran del valor mas proximo (hacia donde se deben dirigir)
# - d: secuencia de grados
# - k: valor deseado de k-anonimidad
#
# Formato: [valor, numero de nodos, distancia minima]
#
def distancia_nodos_inclumpen_kanonymity(d, k):
    # var
    nodos = [];

    # iterate
    for i in range(len(d)):
        v = d.count(d[i]);
        if v < k:
            nodos.append([d[i], v, distancia_mas_proximo(d, d[i])]);

    return nodos;


# Indica la distancia (numero de sumas o restas de +/-1) al nodo mas proximo
# - d: secuencia de grados
# - valor: valor a buscar
#
def distancia_mas_proximo(d, valor):
    distancia_correcta = -1;
    distancia = 1;

    while distancia_correcta < 0:
        if (d.count(valor + distancia) > 0) or (d.count(valor - distancia) > 0):
            distancia_correcta = distancia;

        distancia += 1;

    return distancia_correcta;


# calcula la puntuacion global de un individuo
# - k: valor de k-anonimidad
# - num: numero de nodos que incumplen la k-anonimidad
# - dist: distancia (d-d0)
#
def puntuacion(k_buscada, k, num, dist):
    distancia_objetivo = 0;

    # distancia
    for item in num:
        distancia_objetivo += item[1] * item[2];

    # penalizaciones
    penalizacion = 0;

    if k > k_buscada:
        # distancia al valor buscado de k (penaliza si lo sobrepasa)
        penalizacion += abs(k - k_buscada) * 1000;

    return (k * 1000) - (distancia_objetivo * 10) - (dist * 1) - penalizacion;


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


#
# deprecated
#

#
#
#def asd(_g, _g_original):
#	# debug
#	debug = true;
#	
#	# vars
#	g = copy(_g);
#	g_original = copy(_g_original);
#	
#	# matrices de adyacencia
#	m = g.adjacency_matrix();
#	m_original = g_original.adjacency_matrix();
#	
#	# poner la diagonal a 0's
#	#m = poner_zeros_diagonal(m);
#	#m_original = poner_zeros_diagonal(m_original);
#	
#	#
#	aristas_coincidentes = matrices_and(m, m_original);
#	tmp = matrices_or(m, m_original);
#	aristas_diferencias = tmp - aristas_coincidentes;
#	
#	# debug
#	if debug:
#		print("*** Aristas coincidentes: "+ str(sum(sum(aristas_coincidentes))));
#		print(aristas_coincidentes.str());
#		print("*** Aristas diferencias: "+ str(sum(sum(aristas_diferencias))));
#		print(aristas_diferencias.str());
#	
#	m_aristas_diferencias = matrices_and(m, aristas_diferencias);
#	m_original_aristas_diferencias = matrices_and(m_original, aristas_diferencias);
#	
#	#
#	if debug:
#		print("*** Aristas diferencias en M: "+ str(sum(sum(m_aristas_diferencias))));
#		print(m_aristas_diferencias.str());
#		print("*** Aristas diferencias en ORIGINAL: "+ str(sum(sum(m_original_aristas_diferencias))));
#		print(m_original_aristas_diferencias.str());
#	
#	edge_intersection(g, g_original);
#	
#	# find max swap
#	swap = find_max_swap(m_aristas_diferencias, m_original_aristas_diferencias, m);
#	
#	# debug:
#	if debug:
#		print("[debug]::Greedy_Swap: max_swap: "+str(swap));
#	
#	while len(swap) > 0:
#		# aristas
#		del_e1 = swap[0];
#		del_e2 = swap[1];
#		add_e1 = swap[2];
#		add_e2 = swap[3];
#		
#		# hacer los cambios en los grafos
#		g.delete_edge(del_e1);
#		g.delete_edge(del_e2);
#		
#		e = (add_e1[0], add_e1[1], {});
#		if g.has_edge(e):
#			print("[ERROR] La arista "+str(e)+" ya existe!!")
#		g.add_edge(e);
#		
#		e = (add_e2[0], add_e2[1], {});
#		if g.has_edge(e):
#			print("[ERROR] La arista "+str(e)+" ya existe!!")
#		g.add_edge(e);
#		
#		# actualizar las matrices
#		matriz_poner_valor(m_aristas_diferencias, del_e1, 0);
#		matriz_poner_valor(m_aristas_diferencias, del_e2, 0);
#		matriz_poner_valor(m, add_e1, 1);
#		matriz_poner_valor(m, add_e2, 1);
#		
#		edge_intersection(g, g_original);
#		
#		# find max swap
#		swap = find_max_swap(m_aristas_diferencias, m_original_aristas_diferencias, m);
#		
#		# debug:
#		if debug:
#			print("[debug]::Greedy_Swap: max_swap: "+str(swap));
#	
#	return g;
#
#
##
##
## Formato retorno: [del_e1, del_e2, add_e1, add_e2]
##
#def find_max_swap(m_aristas_diferencias, m_original_aristas_diferencias, m):
#	# vars
#	punto_1 = get_next_point(m_aristas_diferencias, 0, 0);
#	punto_2 = get_next_point(m_aristas_diferencias, punto_1[0], punto_1[1]);
#	
#	candidatos = [];
#	
#	while len(punto_2) > 0:
#		#
#		v = puntuar_swap(punto_1, punto_2, m_original_aristas_diferencias, m);
#		
#		# si la puntuacion es positiva, añadir
#		if v[0] > 0:
#			candidatos.append([punto_1, punto_2, v[1], v[2], v[0]]);
#		
#		punto_2 = get_next_point(m_aristas_diferencias, punto_2[0], punto_2[1]);
#	
#	# escoger el punto con mayor puntuacion
#	if len(candidatos) > 0:
#		candidatos.sort(cmp=lambda x,y: cmp(x[4],y[4]), reverse=True);
#		return  candidatos[0];
#	
#	return ();
#
#
##
##
#def puntuar_swap(punto_1, punto_2, m_original_aristas_diferencias, m):
#	
#	t1_p1 = (punto_1[0], punto_2[0]);
#	t1_p2 = (punto_1[1], punto_2[1]);
#	puntuacion_1 = 0;
#	puntuacion_1 += m_original_aristas_diferencias[t1_p1];
#	puntuacion_1 += m_original_aristas_diferencias[t1_p2];
#	puntuacion_1 -= 10 * m[t1_p1];
#	puntuacion_1 -= 10 * m[t1_p2];
#
#	t2_p1 = (punto_1[0], punto_2[1]);
#	t2_p2 = (punto_1[1], punto_2[0]);
#	puntuacion_2 = 0;
#	puntuacion_2 += m_original_aristas_diferencias[t2_p1];
#	puntuacion_2 += m_original_aristas_diferencias[t2_p2];
#	puntuacion_2 -= 10 * m[t2_p1];
#	puntuacion_2 -= 10 * m[t2_p2];
#	
#	if puntuacion_1 >= puntuacion_2:
#		return (puntuacion_1, t1_p1, t1_p2);
#	
#	return (puntuacion_2, t2_p1, t2_p2);
#
#
##
##
#def get_next_point(matriz, start_x, start_y):
#	x = start_x;
#	y = start_y + 1;
#	
#	while x < matriz.nrows():
#		while y < matriz.ncols():
#			if matriz[x,y] == 1:
#				return (x,y);
#			
#			y += 1;
#		
#		x += 1;
#		y = 0;
#	
#	return ();
#
##
##
#def poner_zeros_diagonal(matriz):
#	for i in range(matriz.ncols()):
#		for j in range(matriz.nrows()):
#			if i >= j:
#				matriz[i,j] = 0;
#	
#	return matriz;
#
#
#def matrices_and(m1, m2):
#	m = matrix(m1.nrows(), m1.ncols());
#	
#	for i in range(m1.nrows()):
#		for j in range(m1.ncols()):
#			m[i,j] = m1[i,j] and m2[i,j];
#	
#	return m;
#
#def matrices_or(m1, m2):
#	m = matrix(m1.nrows(), m1.ncols());
#	
#	for i in range(m1.nrows()):
#		for j in range(m1.ncols()):
#			m[i,j] = m1[i,j] or m2[i,j];
#	
#	return m;
#
#
#def matriz_poner_valor(matriz, punto, valor):
#	x = punto[0];
#	y = punto[1];
#	
#	# poner valor, conservando la simetria
#	matriz[x,y] = valor;
#	matriz[y,x] = valor;
