bisekce<-function(f,a,b){
  fa<-f(a)
  fb<-f(b)
  if(fa*fb<0){
    repeat{
      c<-(a+b)/2
      if(c==a || c==b) break
      fc<-f(c)
      if(fa*fc<0){
        b<-c
        fb<-fc
      }else{
        a<-c
        fa<-fc
      }
    }
    return(c)
  }else{
    return(FALSE)
  }
}

Lagrange<-function(t, x, y){ #t je na?e konkr?tn? x, kter? budeme dosazovat, x je vektor x1, x2, ..., xn
  n<-length(x)
  soucet<-0
  for(i in 1:n){
    soucin<-1
    for(j in 1:n){
      if(j!=i) {
        soucin<-soucin*(t-x[j])/(x[i]-x[j])
      }
    }
    soucet<-soucet + y[i]*soucin
  }
  return(soucet)
}


derivativeforward<-function(x, f, h){
  return ((f(x)-f(x-h))/h)
}

derivativecentral<-function(x, f, h){
  return ((f(x+h)-f(x-h))/2*h)
}






f <- function(x){return(cos(5*acos(x)))}

print(bisekce(f, -1, 1))

x<-(-9:9)/10
y<-f(x)
dy<-derivativeforward(x, f, 0.001)
t<-(-999:999)/1000
ddy<-derivativeforward(x, function(z) derivativeforward(z, f, 0.001), 0.001)

t<-(-999:999)/1000

par(mfrow = c(3, 1))

plot(x, y)
plot(function(t) Lagrange(t, x, y), xlim=c(-1,1), add=TRUE, col='blue')

plot(x, dy)
plot(function(t) Lagrange(t, x, dy), xlim=c(-1,1), add=TRUE, col='red')

plot(x, ddy)
plot(function(t) Lagrange(t, x, ddy), xlim=c(-1,1), add=TRUE, col='green')





