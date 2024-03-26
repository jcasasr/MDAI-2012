###
# RRW functions
###

# carga los resultados de RRW en un array
# - filename: nombre del fichero de resultados
#
def load_rrw_clusters(filename):
	# load from file
	file = open(filename,"r");
	result = [];
	
	for line in file.readlines():
		result.append(line.replace('\n','').split('\t'));
    
	return result;
