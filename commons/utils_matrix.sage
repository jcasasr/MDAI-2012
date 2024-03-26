####################
# MATRIX FUNCTIONS #
####################

def find_value_in_matrix(A, value):
    num_nodes = A.nrows();
    i = int(random()*num_nodes-1);
    j = int(random()*num_nodes-1);
    
    while(A[i,j]!=value):
        j=j+1;
        if j>num_nodes-1:
            j=0;
            i=i+1;
        if i>num_nodes-1:
            i=0;
    
    return (i,j);