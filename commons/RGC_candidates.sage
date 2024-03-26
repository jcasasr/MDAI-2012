load("../commons/RGC_puntuation.sage");
load("../commons/RGC_mutation.sage");
load("../commons/RGC_utils.sage");


def generarPoblacionIncial(original, poblacion_num):
    poblacion = [];
    
    for i in range(poblacion_num):
        poblacion.append(original);

    return poblacion;


def generarCandidato(padre, k_deseada, original_d, original_distanciaObjetivo):
    # timer
    global time_generarCandidato;
    global calls_generarCandidato;
    time_ini = time.time();
    
    #candidato_d = mutar(padre, k_deseada);
    candidato_d = mutar2(padre, k_deseada);
    candidato_k = getKAnonymityValueFromDegreeSequence(candidato_d);
    candidato_punt = getPuntuacion(candidato_d, candidato_k, k_deseada, original_d, original_distanciaObjetivo);

    candidato = [candidato_d, candidato_k, candidato_punt];
    
    # timer
    time_generarCandidato += time.time()-time_ini;
    calls_generarCandidato += 1;
    
    return candidato;


def ordenarIndividuos(todos):
    todos.sort(cmp=lambda x,y: cmp(x[2],y[2]), reverse=True);
    
    return todos;


def seleccionarSiguienteGeneracion(todos, poblacion_num, porcentaje_aleatorio):
    # seleccionar la siguiente generacion
    poblacion = [];

    # 50% - los mejores
    poblacion = todos[0:int(poblacion_num * (1 - porcentaje_aleatorio))];

    # 50% - aleatorio (para mantener la diversidad)
    while len(poblacion) < poblacion_num:
        poblacion.append(todos[randint(0,len(todos)-1)]);
        
    return poblacion;
