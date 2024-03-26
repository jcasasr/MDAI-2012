###
# CALCULO DE VALOR DE K-ANONIMIDAD
###

# @DEPRECATED
def k_anonimity_value(g):
    return getKAnonymityValueFromGraph(g);

# @DEPRECATED
def k_anonimity_value_with_original(g, g_original):
    return max(k_anonimity_value(g), k_anonimity_value(g_original));


# calcular el valor de k-anonimidad de un grafo dado
# - g: grafo
#
def getKAnonymityValueFromGraph(g):
    hist = g.degree_histogram();
    min_value = max(hist);

    for i in range(len(hist)):
        if (hist[i] > 0 and hist[i] < min_value):
            min_value = hist[i];
    
    # no se puede resolver asi porque no hay que considerar los 0.
    #return min(g.degree_histogram());
    
    return min_value;


# indica el valor de k-anonimidad de una secuencia de grados
# - d: secuencia de grados
#
def getKAnonymityValueFromDegreeSequence(d):
    # timer
    #global time_kanonymity_value;
    #global calls_kanonymity_value;
    #time_ini = time.time();
    
    # set k value to max possible value (= number of nodes)
    k = len(d);

    # iterate to find min value
    for i in Set(d):
        num = d.count(i);
        if num < k:
            k = num;

    # timer
    #time_kanonymity_value += time.time()-time_ini;
    #calls_kanonymity_value += 1;

    return k;


def H1_analysis(g):
    dh = g.degree_histogram();
    res = [];
    
    for i in range(1, max(dh)+1):
        res.append(dh.count(i)*i);
    
    #print("DS: "+str(g.degree_sequence()));
    #print("DH: "+str(dh));
    #print("RES:"+str(res));
    
    return res;
