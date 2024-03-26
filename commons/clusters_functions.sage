load("../commons/utils.sage");

###
# Clusters functions
###

# carga los resultados de MCL en un array
# - filename: nombre del fichero de resultados
#
def load_clusters_tab(filename):
    # load from file
    file = open(filename,"r");
    result = [];

    for line in file.readlines():
        result.append(line.replace('\n','').split('\t'));

    return result;

# carga los resultados de MCL en un array
# - filename: nombre del fichero de resultados
#
def load_clusters_space(filename):
    # load from file
    file = open(filename,"r");
    result = [];

    for line in file.readlines():
        result.append(line.replace('\n','').split(' '));
    
    return result;

# print cluster results
# - result: array con las particiones
# - texto: nombre del cluster
#
def print_clusters(result, texto, write_to_file, f1):
    debug = False;
    total = len(result);

    if(debug):
        print("");
        print("*** Conjunto: "+ texto);
        print("Nun. de clusters: "+ str(total) +" ["+ str(calcular_num_items(result)) +" items en total]");
    
        for i in range(total):
            print("   + Cluster "+ str(i) +": "+ str(len(result[i])));

    # open log file
    if write_to_file:
        f1.write("\n");
        f1.write("*** Conjunto: "+ texto +"\n");
        f1.write("Nun. de clusters: "+ str(total) +"\n");
        for i in range(0, total):
            f1.write("   + Cluster "+ str(i) +": "+ str(len(result[i])) +"\n");
        f1.flush();

    return 1;
