
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
