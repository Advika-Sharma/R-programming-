# if statement 
x <- 10
if ( x>5 ) {
    print ("x ix greater than 5")
}

#else statement 
y <- 3
if (y > 5) {
    print("y is greater than 5")
} else {
    print("y ix less than 5")
}

#nested if statement *
z <- 6
if (z > 5){
    if(z > 7){
        print("z ix greater than 7")
    } else {
        print ("z is greater than 5 but not greater than 7 ")
    }
} else {
        print ("z is 5 or less than 5")
    }

#while loop *
count <- 3 
while (count <= 5) {
print(paste("count is:", count))
count <- count+1
}

#for loop *
for ( i in 3:5){
    print(paste("iteration:",i))
}

#break statement *
count <- 3
while (TRUE){
    print(paste("count is:", count))
    if (count >=5) {
        break
    }
    count <- count+1 
}

#next statement *
for (i in 1:5) {
    if ( i %% 2 == 0){ #skips even nos 
        next
    }
    print(paste("odd numbers:",i))
}
 

for (i in 1:5) {
    if ( i %% 2 == 1){ #skips odd nos 
        next
    }
    print(paste("even numbers:",i))
}

#switch statement *
day <- 1 
day_name <- switch (day ,
"1"= "sunday",
"2"= "monday",
"3"= "tuesday",
"4"= "wednesday",
"5"= "thursday",
"6"= "friday",
"7"= "saturday",
"invalid day"
)
print(day_name)

#repeat loop *
count <- 8
repeat {
    print(paste("repeat count", count))
    count <- count+1
    if (count > 5){
        break
    }
}