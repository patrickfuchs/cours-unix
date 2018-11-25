BEGIN {
age=0
count=0
}

/woman/ {
count++
age=age+$4
}

END {
print "total woman:", count
print "mean age:", age/count
}
