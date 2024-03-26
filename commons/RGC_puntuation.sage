load("../commons/RGC_utils.sage");

# calcula la puntuacion global de un individuo
# - k: valor de k-anonimidad
# - num: numero de nodos que incumplen la k-anonimidad
# - dist: distancia (d-d0)
#
def getPuntuacion(d, candidato_k, k_deseada, original_d, original_distanciaObjetivo):
    porcentaje1 = 0.5;
    porcentaje2 = 0.50;
    porcentaje3 = 0.0;
    # timer
    global time_puntuacion;
    global calls_puntuacion;
    time_ini = time.time();
    
    # 1. valor de la K
    puntuacion1 = getPuntuacionK(d, candidato_k, k_deseada) * porcentaje1;
    #print("puntuacion1: "+str(puntuacion1));
       
    # 2. puntuacio nodes que incumpleixen la k-anonimitat
    puntuacion2 = getPuntuacionDistanciaObjetivo(d, k_deseada, original_distanciaObjetivo) * porcentaje2;
    #print("puntuacion2: "+str(puntuacion2));
    
    # 3. distancia al origen
    puntuacion3 = getPuntuacionDistanciaOriginal(d, original_d) * porcentaje3;
    #print("puntuacion3: "+str(puntuacion3));
    
    # TOTAL
    puntuacion = puntuacion1 + puntuacion2 + puntuacion3;
    #print("puntuacion: "+str(puntuacion));
    
    if puntuacion > 1:
        print("ERROR PUNTUACION > 1!!!!!");
        exit();
    
    # timer
    time_puntuacion += time.time()-time_ini;
    calls_puntuacion += 1; 
    
    return puntuacion;


# puntuacion 1
# @return: float[0,1]
def getPuntuacionK(d, candidato_k, k_deseada):
    puntuacion = 0;
    
    if candidato_k >= k_deseada:
        puntuacion = 1;
    
    #print("getPuntuacionK: puntuacion="+str(puntuacion));
    
    return puntuacion;


# puntuacion 2
# @return: float[0,1]
def getPuntuacionDistanciaObjetivo(d, k_deseada, original_distancia):
    puntuacion = 0;
    
#    actual_distancia = distancia_nodos_inclumpen_kanonymity(d, k_deseada);
#    #print("getPuntuacionDistanciaObjetivo: actual_distancia="+str(actual_distancia));
#    
#    if actual_distancia < original_distancia:
#        puntuacion = actual_distancia / original_distancia;
#    
#    #print("getPuntuacionDistanciaObjetivo: puntuacion="+str(puntuacion));
    h = degreeSequenceToDegreeHistogram(d);
    
    # jcasasr 20120402
    #puntuacion = 1 - (nodos_inclumpen_kanonymity(h, k_deseada) / len(d));
    puntuacion = 1 - (getNumNodosIncumplenKAnonimidad(h, k_deseada) / len(d));
    
    return puntuacion;


# Indica el numero de nodos que estan incumpliendo la k-anonimidad para el valor k
# - d: secuencia de grados
# - k: valor deseado de k-anonimidad
#
#def num_nodos_inclumpen_kanonymity(d, k):
#    # var
#    num = 0;
#    
#    # iterate
#    for i in range(len(d)):
#        v = d.count(d[i]);
#        if v < k:
#            num += 1;
#    
#    return num;

def nodos_inclumpen_kanonymity(h, k):
    # var
    valor = 0;

    # iterate
    for v in h:
        if v > 0 and v < k:
            valor += (k - v);

    return valor;


# Indica el numero de nodos que incumplen la k-anonimidad
# @h: histograma de grados
# @k: valor deseado de k-anonimidad
# @return: valor
def getNumNodosIncumplenKAnonimidad(h, k):
    # valor
    valor = 0;
    
    # iterate
    for v in h:
        if v > 0 and v < k:
            valor += v;
    
    return v;


# Indica el numero de nodos que estan incumpliendo la k-anonimidad para el valor k 
# i la distancia a la que se encuentran del valor mas proximo (hacia donde se deben dirigir)
# - d: secuencia de grados
# - k: valor deseado de k-anonimidad
#
# Formato: [valor, numero de nodos, distancia minima]
#
def distancia_nodos_inclumpen_kanonymity(d, k):
    # var
    valor = 0;

    # iterate
    for i in range(len(d)):
        v = d.count(d[i]);
        if v < k:
            valor += distancia_mas_proximo(d, d[i]);

    return valor;


# puntuacion 3
# @return: float[0,1]
def getPuntuacionDistanciaOriginal(d, original_d):
    parcial = distancia(d, original_d);
    total = sum(original_d) * 2;
    puntuacion = (total-parcial) / total;
    
    #print("getPuntuacionDistanciaOriginal: puntuacion="+str(puntuacion));
    
    return puntuacion;
    

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
