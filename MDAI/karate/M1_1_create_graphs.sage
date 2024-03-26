# import
load("globals.sage");
load("../commons/random_perturbation_functions.sage");
load("../commons/k_anonymity_functions.sage");
load("../commons/graphs_functions.sage");
load("../commons/utils_datetime.sage");

# Original
G_original = load(subdir_objects + name_original);

# crear grafo G_randPertur
G_randPertur = [];

# write to file
f1 = open(subdir_results +"time.log","w");

# initial time
time_ini = time.time();

anonimizacion = 0;
anonimizacion_inc = 0.01;
inc = round(num_total / (anonimizacion_max*100));

for i in range(round(num_total/inc)):
    anonimizacion += anonimizacion_inc;
    print("   anonymizing "+str(inc)+" graphs at "+str(anonimizacion));
    
    for j in range(inc):
        G_randPertur.append(random_perturbation(G_original, anonimizacion));

rp_graphs = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];

# Random Perturbation
for i in range(num_total):
    g = G_randPertur[i];
    kvalue = getKAnonymityValueFromGraph(g);
    
    if(kvalue > 1):
        rp_graphs[kvalue].append(g);

# final time
timestr = timestamp_to_string(time.time()-time_ini);

f1.write("CREATE GRAPHS: "+str(num_total)+" graphs\n");
f1.write("CREATE GRAPHS: Total running time "+timestr+"\n");
f1.close();
print("CREATE GRAPHS: Total running time "+timestr);
logging.info("CREATE GRAPHS: Total running time "+timestr);
