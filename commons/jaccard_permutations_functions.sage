###
# CALCULO DEL INDICE DE JACCARD
# calculo extensivo aplicando todas las combinaciones de posibles permutaciones
###

# calcular el indice de Jaccard
# - g1: conjunto de particiones #1
# - g2: conjunto de particiones #2
def jaccard_index_permutations_calcul(g1, g2, total):
    coincidencias = 0;

    # numero de coincidencias
    for i in range(min(len(g1), len(g2))):
        coincidencias = coincidencias + (Set(g1[i]).intersection(Set(g2[i]))).cardinality();
    
    # indice de Jaccard
    jaccard = round(coincidencias / total, 2);
	
    return jaccard;

   
# calcula el indice de Jaccard entre dos particiones (aplica permutaciones para explorar todas las posibles combinaciones)
# - set1: conjunto de particiones #1
# - set2: conjunto de particiones #2
#
def jaccard_index_permutations(set1, set2, debug, write_to_file, f1):
	
    logging.debug("Calc Jaccard index")

    # numero total
    num_total_items = max(num_items(set1), num_items(set2));

    # generar las permutaciones
    num_elementos_permutacion = min(len(set1), len(set2));

    if len(set1) <= len(set2):
        set = copy(set1);
        set_permutations = Arrangements(set2, num_elementos_permutacion);

    if len(set2) < len(set1):
        set = copy(set2);
        set_permutations = Arrangements(set1, num_elementos_permutacion);

    num_permutaciones = set_permutations.cardinality();

    if debug:
        print("[debug]: Conjunto 1 con "+ str(len(set)) +" particiones. Conjunto 2 con "+ str(num_permutaciones) +" permutaciones de "+ str(len(set_permutations[0])) +" elementos.");
    if write_to_file:
        f1.write("[debug]: Conjunto 1 con "+ str(len(set)) +" particiones. Conjunto 2 con "+ str(num_permutaciones) +" permutaciones de "+ str(len(set_permutations[0])) +" elementos.\n");

    ###
    # calcular el indice de Jaccard para cada permutacion
    ###
    ij = 0;
    i = 1;
    show_percent = max(1, round(num_permutaciones / 100, 0));

    for subset in set_permutations:
        ij_tmp = jaccard_index_permutations_calcul(set, subset, num_total_items);
        # comparar con el IJ actual y asignar si es mejor
        logging.debug("Compare previous jaccard_index (" + str(i) + ") with actual (" + str(ij) + ")");
        if ij_tmp > ij:
            ij = ij_tmp;
            if debug:
                print("[debug]: Nuevo IJ encontrado = "+ str(ij) +" ["+ str(i) +" de "+ str(num_permutaciones) +"]");
            if write_to_file:
                f1.write("[debug]: Nuevo IJ encontrado = "+ str(ij) +" ["+ str(i) +" de "+ str(num_permutaciones) +"]\n");

        # muestra el '%' de realizacion
        if i % show_percent == 0:
            print("... "+ str(round(i*100/num_permutaciones, 0)) +"% completed!");

        # IJ == 1, no es necesario continuar
        if ij == 1:
            print("+++ Indice de Jaccard = "+ str(ij));
            if write_to_file:
                f1.write("+++ Indice de Jaccard = "+ str(ij) +"\n");
            return ij;

        i = i+1;

    ###
    # fin del calculo
    ###

    # devolver el valor mas alto
    print("+++ Indice de Jaccard = "+ str(ij));

    if write_to_file:
            f1.write("+++ Indice de Jaccard = "+ str(ij) +"\n");

    logging.info("[DONE]Calc Jaccard index. Index="+str(ij))

    return ij;

