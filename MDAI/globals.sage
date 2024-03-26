import logging;
import time;

# data set
data_set = 3;

###########
# Zachary #
###########
if data_set == 1:
    name_dataset = 'karate';
    num_total = 5000;
    anonimizacion_max = 0.5;
    # % de incremento perturbacion / iteracion
    inc_randomAnonim = 0.01;
    # path
    path = "/SAGE/MDAI/";
    exp = "karate/";

############
# Football #
############
if data_set == 2:
    name_dataset = 'football';
    num_total = 5000;
    anonimizacion_max = 0.5;
    # % de incremento perturbacion / iteracion
    inc_randomAnonim = 0.01;
    # path
    path = "/SAGE/MDAI/";
    exp = "football/";

########
# Jazz #
########
if data_set == 3:
    name_dataset = 'jazz';
    num_total = 5000;
    anonimizacion_max = 0.5;
    # % de incremento perturbacion / iteracion
    inc_randomAnonim = 0.01;
    # path
    path = "/SAGE/MDAI/";
    exp = "jazz/";


##########
# Params #
##########

tamano_fuente = 14;
tamano_fuente_legend = 14;
inc_step = int(inc_randomAnonim * 100);

#########
# Paths #
#########
#
# DON'T TOUCH!!
#

# Colores para impresiones
plot_color_original = 'grey';
plot_style_original = ':';
plot_color_randPertur = Color(0.7,0.7,0.7);
plot_style_randPertur = '-';
plot_color_randSwitch = Color(0,0,0);
plot_style_randSwitch = '--';

colors = ['red','blue','orange','yellow','green','grey','brown','pink','purple','magenta'];

# Paths
subdir = path + exp;
subdir_objects = path + exp +"objects/";
subdir_results = path + exp +"results/";
subdir_exports = path + exp +"export/";
subdir_tmp = path + exp +"tmp/";
name_original = "G_original";
name_randpertur = "G_rand_pertur";
name_randswitch = "G_rand_switch";

# Logging format,file and level
# Los distintos niveles segun el texto que se quiere que se imprima son:
#  DEBUG, INFO, WARNING, ERROR y CRITICAL
log_file = path +"mdai-log.log";
logging.basicConfig(format='%(asctime)s - %(levelname)s \t- %(message)s',filename=log_file,level=logging.DEBUG);

logging.info("*** DATASET = "+str(data_set)+" ["+path+exp+"]")