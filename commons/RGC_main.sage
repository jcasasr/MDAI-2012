load("../commons/RGC_greedySwap.sage");
load("../commons/RGC_constructGraphSequence.sage");


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
    #d_original = g_original.degree_sequence();
    d_original = getNoOrderedDegreeSequence(g_original);

    logging.info("RGC: Grafo original: "+str(g_original.num_verts())+" nodos y "+str(g_original.num_edges())+" aristas.");
    logging.info("RGC: Secuencia original: "+str(d_original));
    logging.info("RGC: Grado de k-anonimidad = "+str(getKAnonymityValueFromDegreeSequence(d_original)));

    # anonimizar la secuencia de grados segun el valor de k
    d_anonimizada = ConstructGraphSequence(d_original, k);
    
    logging.info("RGC: Secuencia anonimizada: "+str(d_anonimizada));
    logging.info("RGC: Grado de k-anonimidad = "+str(getKAnonymityValueFromDegreeSequence(d_anonimizada)));
    logging.info("RGC: Distancia a la secuencia original = "+str(distancia(d_anonimizada, d_original)));

#    # Construir el grafo a partir de la secuencia de grados (d')
#    g0 = graphs.DegreeSequence(d_anonimizada);
#
#    logging.info("RGC: Grafo reconstruido a partir de la secuencia anonimizada: "+str(g0.num_verts())+" nodos y "+str(g0.num_edges())+" aristas.");
#    edge_intersection(g0, g_original);
#
#    # aplicar Greedy Swap
#    g = Greedy_Swap(g0, g_original);
#
#    logging.info("RGC: Grafo anonimizado: "+str(g.num_verts())+" nodos y "+str(g.num_edges())+" aristas.");
#    edge_intersection(g, g_original);
    
    # final time
    timestr = timestamp_to_string(time.time()-time_ini);
    print("RGC: Total running time "+timestr);
    logging.info("RGC: Total running time "+timestr);

#    return g;


time_constructGraphSequence = 0;
calls_constructGraphSequence = 0;
time_generarCandidato = 0;
calls_generarCandidato = 0;
time_mutar = 0;
calls_mutar = 0;
time_kanonymity_value = 0;
calls_kanonymity_value = 0;
time_puntuacion = 0;
calls_puntuacion = 0;

def mostrarTiemposConstructGraphSequence():
    global time_generarCandidato;
    global time_mutar;
    global time_kanonymity_value;
    global time_puntuacion;
    
    # time
    printTiempoFuncion(time_constructGraphSequence, calls_constructGraphSequence, "ConstructGraphSequence", 0);
    printTiempoFuncion(time_generarCandidato, calls_generarCandidato, "GenerarCandidato", 1);
    printTiempoFuncion(time_mutar, calls_mutar, "Mutar", 2);
    printTiempoFuncion(time_kanonymity_value, calls_kanonymity_value, "kanonymity_value", 2);
    printTiempoFuncion(time_puntuacion, calls_puntuacion, "Puntuacion", 2);


def printTiempoFuncion(fTime, calls, nombreFuncion, nivel):
    sTime = timestamp_to_string(fTime);
    sCadena = "";
    for i in range(nivel):
        if i == nivel - 1:
            sCadena = sCadena+"+";
        if i < nivel -1:
            sCadena = sCadena+" ";
    sCadena += "- "+nombreFuncion+": ("+str(calls)+" calls) "+sTime;
    print(sCadena);
    logging.info(sCadena);

