###
# CALCULO DEL INDICE DE JACCARD
# segun la matriz de coincidencias
###


# calcula el indice de Jaccard entre dos particiones
# - set1: conjunto de particiones #1
# - set2: conjunto de particiones #2
#
def jaccard_index_table(set1_ori, set2_ori, debug, write_to_file, f1):
    # realizar copia para preservar los conjuntos originales de datos
    set1 = copy(set1_ori);
    set2 = copy(set2_ori);

    # generar la tabla
    table = crear_lista(len(set1), len(set2));

    i = 0;
    for s1 in set1:
        j = 0;
        for s2 in set2:
            table[i][j] = (Set(s1).intersection(Set(s2))).cardinality();
            j = j+1;
        i = i+1;

    # inicializar valores
    ij = 0;
    matching_pairs = [];

    # numero total de elementos
    total = max(calcular_num_items(set1), calcular_num_items(set2));
	
    # matching de mayor puntuacion para determinar el cruce de clusters
    for index in range(min(len(set1), len(set2))):
        max_value = 0;
        max_others = 0;
        max_col = -1;
        max_row = -1;

        # debug
        if debug:
            print("*** Step "+ str(index+1) +" ***");
            print("    set 1 ("+ str(len(set1)) +"): "+ str(set1));
            print("    set 2 ("+ str(len(set2)) +"): "+ str(set2));
        if write_to_file:
            f1.write("*** Step "+ str(index+1) +" ***\n");
            f1.write("    set 1 ("+ str(len(set1)) +"): "+ str(set1) +"\n");
            f1.write("    set 2 ("+ str(len(set2)) +"): "+ str(set2) +"\n");
            f1.flush();

        # buscar el valor maximo
        for i in range(len(table)):
            for j in range(len(table[0])):
                # se coje el valor maximo
                if table[i][j] > max_value:
                    max_value = table[i][j];
                    max_others = max(max(table[i]), max_columna(table,j));
                    max_row = i;
                    max_col = j;

                # en caso de dos valores maximos iguales
                if table[i][j] == max_value:
                    tmp = max(max(table[i]), max_columna(table,j));
                    if tmp < max_others:
                        max_value = table[i][j];
                        max_others = tmp;
                        max_row = i;
                        max_col = j;

        # asociar
        ij = ij + max_value;
        matching_pairs.append("Matching "+ str(index+1) +": ("+ str(max_row) +","+ str(max_col) +") <--> "+ str(set1[max_row]) +" - "+ str(set2[max_col]));

        # eliminar las particiones seleccionadas en este paso
        set1.pop(max_row);
        set2.pop(max_col);

        # debug
        if debug:
            print_table(table);
            print("    IJ = "+ str(ij));
            print("    "+ str(matching_pairs[len(matching_pairs)-1]));
        if write_to_file:
            print_table_to_file(table, f1);
            f1.write("    IJ = "+ str(ij) +"\n");
            f1.write("    "+ str(matching_pairs[len(matching_pairs)-1]) +"\n");
            f1.flush();

        # eliminar de table y continuar con la busqueda
        table = eliminar_fila(max_row, table);
        table = eliminar_columna(max_col, table);

    # Indice de Jaccard
    ij = round(ij / total, 6);

    if(debug):
        print("");
        print("*** Indice de Jaccard: "+ str(ij));

    if write_to_file:
        f1.write("*** Indice de Jaccard: "+ str(ij) +"\n");
        f1.flush();

    return ij;


# crea una lista de rows*cols
# - rows: numero de filas
# - cols: numero de columnas
#
def crear_lista(rows, cols):
    tmp = [];

    for i in range(rows):
        tmp.append([]);
        for j in range(cols):
            tmp[i].append(0);

    return tmp;


# elimina una fila de una lista doble
# - i: indice de la fila a eliminar (0..m)
# - table: lista m x n
#
def eliminar_fila(i, table):
    table.pop(i);

    return table;


# elimina una columna de una lista doble
# - i: indice de la columna a eliminar (0..n)
# - table: lista m x n
#
def eliminar_columna(j, table):
    for s in table:
        s.pop(j);

    return table;


# devuleve el valor maximo de una columna
# - table: tabla
# - j: columna
#
def max_columna(table, j):
    value = 0;
    for i in range(len(table)):
        value = max(value, table[i][j]);

    return value;


# printa la tabla
# - table: la tabla
#
def print_table(table):
    for fila in table:
        print("    "+ str(fila));


# printa la tabla en un fichero
# - table: la tabla
# - f1: fichero
#
def print_table_to_file(table, f1):
    for fila in table:
        f1.write("    "+ str(fila) +"\n");
