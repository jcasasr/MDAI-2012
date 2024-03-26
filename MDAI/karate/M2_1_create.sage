# import
load("globals.sage");
load("../commons/random_perturbation_functions.sage");
load("../commons/k_anonymity_functions.sage");
load("../commons/graphs_functions.sage");
load("../commons/utils_datetime.sage");

def rp_anonymization(g_original, k_deseada, f1):
    # initial time
    time_ini = time.time();
    # params
    anonimizacion = 0.01;
    anonimizacion_inc = 0.01;
    num_item = 100;
    max = 5000;
    
    # print
    print("*** RP anonymization process k="+str(k_deseada)+" starting...");
    f1.write("*** RP anonymization process k="+str(k_deseada)+" starting\n");
    
    i = 0;
    hay_solucion = False;
    solucion = [];
    stop = false;
    while not(stop):
        i += 1;
        if i % num_item == 0:
            if anonimizacion < 0.5:
                anonimizacion += anonimizacion_inc;
            print("   Porcentaje anonimizacion = "+str(anonimizacion)+", total grafos anonimizados = "+str(i));
            f1.write("   Porcentaje anonimizacion = "+str(anonimizacion)+", total grafos anonimizados = "+str(i)+"\n");
        
        g = random_perturbation(g_original, anonimizacion);
        k = getKAnonymityValueFromGraph(g);
        
        if k_deseada == k:
            hay_solucion = True;
            solucion = [g];
        
        if hay_solucion or i > max:
            stop = true;
    
    # final time
    timestr = timestamp_to_string(time.time()-time_ini);
    # print
    print("*** RP anonymization process k="+str(k_deseada)+" [graphs="+str(i)+", Time="+str(timestr)+"]\n");
    f1.write("*** RP anonymization process k="+str(k_deseada)+" [graphs="+str(i)+", Time="+str(timestr)+"]\n");
    
    return solucion;


# Original
G_original = load(subdir_objects + name_original);

# write to file
f1 = open(subdir_results +"time.log","w");

rp_graphs = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
rp_graphs[2] = rp_anonymization(G_original, 2, f1);
save(rp_graphs, subdir_tmp+"rp_graphs");
rp_graphs[3] = rp_anonymization(G_original, 3, f1);
save(rp_graphs, subdir_tmp+"rp_graphs");
rp_graphs[4] = rp_anonymization(G_original, 4, f1);
save(rp_graphs, subdir_tmp+"rp_graphs");
rp_graphs[5] = rp_anonymization(G_original, 5, f1);
save(rp_graphs, subdir_tmp+"rp_graphs");

f1.close();
