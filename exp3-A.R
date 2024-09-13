#Write R functions to perform common tasks
# function to add 2 numbers
add_num <- function(a,b)
{
sum_result <- a+b
return(sum_result)
}
# calling add_num function
sum = add_num(35,34)
#printing result
print("sum")
print(sum)


# A simple R program to demonstrate
# passing arguments to a function

Rectangle = function(length=5, width=4){
area = length * width
return(area)
}
print("rectangle")
print(Rectangle())


# A simple R function to calculate 
# area of a circle

areaOfCircle = function(radius){
area = pi*radius^2
return(area)
}
print("area")
print(areaOfCircle(2))

#factorial of a no
factorial <- function(n) {
  result <- 1
  for (i in 1:n) {
    result <- result * i
  }
  return(result)
}

result <- factorial(5)
print("fact")
print(result) 

#inbuild functions 
print(max(mtcars))
print(min(mtcars))