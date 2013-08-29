# script of R commands 
library(igraph)
g <- graph.data.frame(d,directed=FALSE)
z <- length(V(g))
y <- length(E(g))
x <- graph.density(g)
w <- clusters(g)$no
v <- transitivity(g,"global")
t <- graph.adhesion(g)
s <- diameter(g)
r <- average.path.length(g)
#rstr <- paste(z,y,x,w,v,t,s,r, sep = '\t', collapse = '\n')
rstr <- cat(z, "\t", y, "\t", x, "\t", w, "\t", v, "\t", t, "\t", s, "\t", r, "\n")
