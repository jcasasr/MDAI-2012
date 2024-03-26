load("../commons/RGC_utils.sage");


def mutar2(d_original, k):
    # debug
    debug = false;
    # timer
    global time_mutar;
    global calls_mutar;
    time_ini = time.time();
    
    # vars
    d = copy(d_original);
    h = degreeSequenceToDegreeHistogram(d);
    len_h = len(h);
    # 1 < num_mutaciones < 10% numero de nodos
    num_mutaciones = 1; #randint(1, int(0.1*len(d)));
    nodos_no_cumplen = [];
    nodos_cumplen = [];
    nodos_pueden_restar1 = [];
    nodos_pueden_sumar1 = [];
    
    # jcasasr 20120402
    valor_medio = list_average(d_original);
    
    # seleccionar nodos
    for i in range(len(d)):
        grado_i = d[i];
        
        # nodos que no cumplen
        if h[grado_i] < k:
            nodos_no_cumplen.append(i);
        
        # nodos que cumplen (justo)
        if h[grado_i] == k:
            nodos_cumplen.append(i);
            
        # nodos que cumplen y pueden modificar su grado
        if h[grado_i] > k:
            if h[grado_i-1] >= k-1 and (grado_i-1 >= 1):
                nodos_pueden_restar1.append(i);
            if grado_i+1 < len_h and h[grado_i+1] >= k-1:
                nodos_pueden_sumar1.append(i);
    
    # aplicar mutaciones
    for i in range(num_mutaciones):
        if len(nodos_no_cumplen) > 0:
            # nodo 1 OP nodo 2
            
            # selecionar nodo 1
            nodo_1 = nodos_no_cumplen[randint(0, len(nodos_no_cumplen)-1)];
            
            # seleccionar operacion
            if len(nodos_pueden_restar1) > 0 and len(nodos_pueden_sumar1) > 0:
                # 50%
                # jcasasr 20120402
#                rand = randint(0,10);
#                if rand > 5:
#                    tipo_intercambio = 'restar_al_nodo1';
#                    
#                if rand <= 5:
#                    tipo_intercambio = 'sumar_al_nodo1';
                if d[nodo_1] >= valor_medio:
                    tipo_intercambio = 'restar_al_nodo1';
                if d[nodo_1] < valor_medio:
                    tipo_intercambio = 'sumar_al_nodo1';
                
                
            if (len(nodos_pueden_restar1) > 0 and len(nodos_pueden_sumar1) == 0):
                tipo_intercambio = 'sumar_al_nodo1';
                
            if len(nodos_pueden_restar1) == 0 and len(nodos_pueden_sumar1) > 0:
                tipo_intercambio = 'restar_al_nodo1';
            
            if d[nodo_1] <= 1:
                tipo_intercambio = 'sumar_al_nodo1';
                
            # seleccionar nodo 2
            if tipo_intercambio == 'sumar_al_nodo1':
                nodo_2 = nodos_pueden_restar1.pop(randint(0, len(nodos_pueden_restar1)-1));
                
            if tipo_intercambio == 'restar_al_nodo1':
                nodo_2 = nodos_pueden_sumar1.pop(randint(0, len(nodos_pueden_sumar1)-1));
            
            # aplicar operacion
            if tipo_intercambio == 'sumar_al_nodo1':
                d[nodo_1] = d[nodo_1]+1;
                d[nodo_2] = d[nodo_2]-1;
            
            if tipo_intercambio == 'restar_al_nodo1':
                d[nodo_1] = d[nodo_1]-1;
                d[nodo_2] = d[nodo_2]+1;
            
    # timer
    time_mutar += time.time()-time_ini;
    calls_mutar += 1;

    return d;


#
#
#
def mutar_n_veces(d_original, k):
    numMutaciones = randint(0,5);
    
    for i in range(numMutaciones):
        d_original = mutar1(d_original, k);
        
    return d_original;


# aplica 1 mutacion a la secuencia dada, intentado que se aproxime a un valor superior de k
# - d_original: secuencia de grados
# - k: valor de k-anonimidad
#
def mutar1(d_original, k):
    # debug
    debug = false;
    # timer
    global time_mutar;
    global calls_mutar;
    time_ini = time.time();

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

    # timer
    time_mutar += time.time()-time_ini;
    calls_mutar += 1;

    return d;

