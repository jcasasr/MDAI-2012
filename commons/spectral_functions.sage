###
# Spectral functions
###

def getFirstEigenvalueOfAdjacencyMatrix(g):
    eigenvalues = g.spectrum();
    return eigenvalues[0];

def getSecondEigenvalueOfLaplacianMatrix(g):
    eigenvalues = g.spectrum(laplacian=True);
    return eigenvalues[1];
