#vectors= vectors are created for one or more elements. if we want to combine the elements into a vector we use the function c (the c function is known as combining function)
b <- c('green',2,'red')
print(class(b))

#matrix = a matrix is a 2 dimensional rectangular dataset it can be created using a vector Input to the matrix function for creating a matrix 
M= matrix (c('a','a','b','c','b','a'), nrow = 2 , ncol=3, byrow=FALSE)
print(M)

#array = while the matrices are confined to two dimensions the arrays can be of any no of dimensions the function array takes a dim attribute which creates the required no of dimensions
a <- array(c('green','yellow'),dim=c(3,3,2))
print(a)

#a list is an R object which can contain many differnt types of elements inside it like vectors, functions and other items 
list1 <- list(c(2,5,3),21.3,sin)
print(list1)

#factors = these are the R objects which are created using a vector it stores the vector along with distinct values of the elements in the vectors as labels the labels are always characters irrespective of whether there r numeric character or boolen values in the vector 
colors <- c('green','green','red','red','blue')
factor_colors <- factor(colors)
print(factor_colors)
print(nlevels(factor_colors)) 