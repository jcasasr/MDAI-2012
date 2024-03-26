load("../commons/RGC_candidates.sage");
load("../commons/RGC_mutation.sage");
load("../commons/RGC_puntuation.sage");
load("../commons/RGC_utils.sage");


# Aplicar algoritmos geneticos para conseguir una secuencia que:
# 1) cumpla la restriccion de sum(d) == sum(d')
# 2) minimize la distancia (d - d')
#
def ConstructGraphSequence(original_d, k):
    # params
    poblacion_num = 500;
    descendientes_num = 10; # descendientes por cada individuo
    porcentaje_aleatorio = 0.7;
    max_num_iteraciones_sin_mejora_con_solucion = 5;
    max_num_iteraciones_sin_mejora_sin_solucion = 50;
    # bucle principal
    iteracion = 0;
    mejor_puntuacion = [];
    mejor_k = 0;
    no_mejora_sin_solucion = false;
    no_mejora_con_solucion = false;
    hay_solucion_valida = false;
    # timer
    global time_constructGraphSequence;
    global calls_constructGraphSequence;
    time_ini = time.time();

    # crear individuo original
    #
    # Formato de cada individuo: [[degree_sequence], k, puntuacion]
    # - k: valor actual de k-anonimidad
    # - puntuacion: valor de puntuacion de la funcion de fittness
    original_k = getKAnonymityValueFromDegreeSequence(original_d);
    original_distanciaObjetivo = distancia_nodos_inclumpen_kanonymity(original_d, k);
    original_punt = getPuntuacion(original_d, original_k, k, original_d, original_distanciaObjetivo);
    
    original = [original_d, original_k, original_punt];

    # comprovacion
    if original_k >= k:
        logging.info("ConstructGraphSequence: La secuencia ya es "+ str(k) +"-anonima!");
        print("La secuencia ya es "+ str(k) +"-anonima!");
        return original[0];

    # debug
    logging.debug("ConstructGraphSequence: secuencia original k="+ str(original_k) +" --> objetivo k="+ str(k));

    # generar nueva poblacion inicial
    poblacion = generarPoblacionIncial(original, poblacion_num);

    # bucle principal
    while (hay_solucion_valida and (no_mejora_con_solucion == false)) or (not(hay_solucion_valida) and (no_mejora_sin_solucion == false)):
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
                candidato = generarCandidato(poblacion[i][0], k, original_d, original_distanciaObjetivo);

                # add
                if not(candidato in descendientes):
                    descendientes.append(candidato);

        # debug
        logging.debug("ConstructGraphSequence: Evaluando candidatos [poblacion = "+str(len(poblacion))+", descendientes = "+str(len(descendientes))+"]");

        # ordenadar los individuos
        todos = ordenarIndividuos(poblacion + descendientes);
        
        # debug
        logging.debug("ConstructGraphSequence: Seleccionando los mejores candidatos...");

        # seleccionar la siguiente generacion
        poblacion = seleccionarSiguienteGeneracion(todos, poblacion_num, porcentaje_aleatorio);

        # debug
        for i in range(3):
            logging.debug("ConstructGraphSequence: Individuo "+str(i)+": "+str(poblacion[i]));

        # control de parada
        mejor_k = todos[0][1];
        mejor_puntuacion.append(todos[0][2]);
        no_mejora_con_solucion = pararPorNumeroIteracionesConSolucion(iteracion, k, mejor_k, max_num_iteraciones_sin_mejora_con_solucion, mejor_puntuacion);
        no_mejora_sin_solucion = pararPorNumeroIteracionesSinSolucion(iteracion, k, mejor_k, max_num_iteraciones_sin_mejora_sin_solucion, mejor_puntuacion);
        
        if mejor_k >= k:
            hay_solucion_valida = true;
        
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
    
    # timer
    time_constructGraphSequence += time.time()-time_ini;
    calls_constructGraphSequence += 1;
    
    mostrarTiemposConstructGraphSequence();

    return best_candidate[0];


# Control de parada 
#
# @return: boolean
def pararPorNumeroIteracionesConSolucion(iteracion, k, mejor_k, max_num_iteraciones_sin_mejora_con_solucion, mejor_puntuacion):
    no_mejora = false;
    
    if mejor_k >= k:
        if iteracion > max_num_iteraciones_sin_mejora_con_solucion:
            if mejor_puntuacion[iteracion - max_num_iteraciones_sin_mejora_con_solucion] >= mejor_puntuacion[iteracion]:
                no_mejora = true;
                # debug
                logging.debug("pararPorNumeroIteracionesConSolucion: No se han detectado mejoras en las ultimas "+str(max_num_iteraciones_sin_mejora_con_solucion)+" iteraciones!");
                logging.debug("pararPorNumeroIteracionesConSolucion: Parando ejecucion...");
            
    return no_mejora;

# Control de parada 
#
# @return: boolean
def pararPorNumeroIteracionesSinSolucion(iteracion, k, mejor_k, max_num_iteraciones_sin_mejorasin_solucion, mejor_puntuacion):
    no_mejora = false;
    
    if mejor_k < k:
        if iteracion > max_num_iteraciones_sin_mejorasin_solucion:
            if mejor_puntuacion[iteracion - max_num_iteraciones_sin_mejorasin_solucion] >= mejor_puntuacion[iteracion]:
                no_mejora = true;
                # debug
                logging.debug("pararPorNumeroIteracionesSinSolucion: No se han detectado mejoras en las ultimas "+str(max_num_iteraciones_sin_mejorasin_solucion)+" iteraciones!");
                logging.debug("pararPorNumeroIteracionesSinSolucion: Parando ejecucion...");
            
    return no_mejora;
