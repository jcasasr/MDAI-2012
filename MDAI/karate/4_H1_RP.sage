# import
load("globals.sage");
load("../commons/print_info.sage");
load("../commons/utils.sage");
load("../commons/utils_list.sage");
load("../commons/utils_dict.sage");
load("../commons/k_anonymity_functions.sage");


# LOAD
rp_graphs = load(subdir_tmp+"rp_graphs");
gga_graphs = load(subdir_tmp+"gga_graphs");


asd = [];
num_nodes = G_original.num_verts();

rp_graphs[1] = [G_original];

for i in range(len(rp_graphs)):
    if not(rp_graphs[i] == []):
        asd.append(H1_analysis(rp_graphs[i][0]));
    if rp_graphs[i] == []:
        asd.append([]);

# copiar
asd_numeros = [];

for i in range(len(asd)):
    tmp = [];
    for j in range(len(asd[i])):
        tmp.append(round(asd[i][j], 2));
    
    asd_numeros.append(tmp);

# calcular en porcentajes
for i in range(len(asd)):
    for j in range(len(asd[i])):
        asd[i][j] = round(asd[i][j]/float(num_nodes)*100, 4);

# group
groups = [[1,1],[2,4],[5,10],[11,100]];

resum = [];
for i in range(len(asd)):
    fila = [];
    
    for g in groups:
        ini = g[0]-1;
        end = g[1]-1;
        v = 0;
        
        for j in range(ini, end+1):
            if len(asd[i]) > j:
                v += asd[i][j];
    
        fila.append(v);
        
    resum.append(fila);

# rows <-> cols
qwe = [];

for j in range(len(groups)):
    fila = [];
    for i in range(len(resum)):
        fila.append(resum[i][j]);

    qwe.append(fila);

# write to file
f1 = open(subdir_results +"H1-RP.log","w");
# segun el numero de nodos
f1.write("----------------\n");
f1.write("NUMERO DE NODOS:\n");
f1.write("----------------\n");
f1.write(str(groups)+"\n");
for i in range(len(asd_numeros)):
    f1.write("k="+str(i)+" "+str(asd_numeros[i])+"\n");
# segun el porcentage
f1.write("----------------\n");
f1.write("PORCENTAJE:\n");
f1.write("----------------\n");
f1.write(str(groups)+"\n");
for i in range(len(resum)):
    f1.write("k="+str(i)+" "+str(resum[i])+" [Total "+str(list_sum_allvalues(resum[i]))+"%]\n");
# segun el rango
f1.write("----------------\n");
f1.write("RANGO:\n");
f1.write("----------------\n");
for i in range(len(qwe)):
    f1.write(str(groups[i])+" - "+str(qwe[i])+"\n");

f1.close();

# grafica RMS
colors_bw = [Color(0.7,0.7,0.7), Color(0.5,0.5,0.5), Color(0.3,0.3,0.3), Color(0,0,0), 'grey', 'brown', 'pink', 'orange', 'magenta', 'yellow'];
colors = ['red','orange','blue', 'green','magenta','grey'];
markers = ['.', '*', '+', '^', 's', 'o', 'x', 'p'];
linestyle = ["-", "--", "-.", ":"];
x_values = [1,2,3,4];

for i in range(len(qwe)):
    zxc = [];
    for j in x_values:
        zxc.append((j, qwe[i][j]));
    
    if not(qwe[i] == []):
        fig_rp = list_plot(zxc, plotjoined=true, color=colors[i], marker=markers[i], linestyle=linestyle[0], legend_label=str(groups[i]));
        if i == 0:
            figure = fig_rp;
        if i > 0:
            figure = figure + fig_rp;

figure.axes_labels(['K','Nodes (%)']);
figure.set_axes_range(ymin=0, ymax=100);
figure.set_axes_range(xmin=1, xmax=5);
figure.set_legend_options(loc=0);
figure.set_legend_options(font_size=tamano_fuente_legend);
figure.fontsize(tamano_fuente);
figure.save(subdir_results +"H1-RP-colors.png", frame=false);
