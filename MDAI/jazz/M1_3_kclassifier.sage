# import
load("globals.sage");
load("../commons/k_anonymity_functions.sage");
load("../commons/graphs_functions.sage");

logging.debug("Classify graphs from their k-anonymity value");

rp_graphs = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
gga_graphs = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];

# Random Perturbation
for i in range(num_total):
    g = G_randPertur[i];
    kvalue = getKAnonymityValueFromGraph(g);
    
    if(kvalue > 1):
        rp_graphs[kvalue].append(g);

# GGA
gga_graphs[2].append(load(subdir_objects+"jazz_k=2_graph"));

print("Graphs classified!");
logging.debug("Graphs classified!");

# verification
for i in range(len(rp_graphs)):
    set = rp_graphs[i];
    
    for g in set:
        if i <> getKAnonymityValueFromGraph(g):
            print("*** ERROR: graph with an incorrect K-VALUE! [k="+str(i)+"]");
            logging.error("graph with an incorrect K-VALUE! [k="+str(i)+"]");

for i in range(len(gga_graphs)):
    set = gga_graphs[i];
    
    for g in set:
        if i <> getKAnonymityValueFromGraph(g):
            print("*** ERROR: graph with an incorrect K-VALUE! [k="+str(i)+"]");
            logging.error("graph with an incorrect K-VALUE! [k="+str(i)+"]");

print("Verification completed!");
logging.debug("Verification completed!");

# select best candidates
def selectBestGraph(gl):
    res = [];
    
    for lista in gl:
        if lista == []:
            res.append([]);
        if not(lista == []):
            mejor_v = 0;
            mejor_g = [];
            
            for g in lista:
                v = edge_intersection(G_original, g);
                
                if v > mejor_v:
                    mejor_v = v;
                    mejor_g = g;
            
            res.append([mejor_g]);
    
    return res;

rp_graphs_all = copy(rp_graphs);
rp_graphs = selectBestGraph(rp_graphs_all);

print("Selected best candidates!");
logging.debug("Selected best candidates!");

# print
f1 = open(subdir +"rp_graphs.log","w");
f1.write("K\tRP-a\tRP\tGGA\n");

for i in range(len(rp_graphs)):
    f1.write(str(i)+"\t"+str(len(rp_graphs_all[i]))+"\t"+str(len(rp_graphs[i]))+"\t"+str(len(gga_graphs[i]))+"\n");

f1.close();

print("Info printed!");
logging.debug("Info printed!");

# SAVE
save(rp_graphs_all, subdir_tmp+"rp_graphs_all");
save(rp_graphs, subdir_tmp+"rp_graphs");
save(gga_graphs, subdir_tmp+"gga_graphs");

print("Workspace objects saved!");
logging.debug("Workspace objects saved!");

logging.debug("[DONE] Classify graphs from their k-anonymity value");
