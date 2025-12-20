# Máme soustavu lineárních rovnic Ax = b
# Matice A není daná čísly, ale vzorcem s integrálem
# Každý prvek vektoru b je součet řádku matice
# Počet neznámých N od 2 do 20.

# i = řádek matice
# j = sloupec matice

GaussE <- function(A, b){
  n<-length(b)
  A<-cbind(A, b) #vytvoření rozdělení matice
  
  #PŘÍMÝ CHOD
  for(k in 1:(n-1)){
    for(i in (k+1):n){
      c<- -A[i,k]/A[k,k]
      for(j in (k+1):(n+1)){
        A[i,j]<-A[i,j] + c*A[k,j]
      }
    }
  }
  #ZPĚTNÝ CHOD
  x<-A[,n+1] #nadefinujeme x, definujeme ho jako poslední sloupec matice A (vektor pravých stran)
  x[n]<- x[n]/A[n,n]
  for(i in (n-1):1){
    x[i] = (x[i]-sum(A[i, (i+1):n]*x[(i+1):n]))/A[i,i] #suma z výpisků
  }
  return(x)
}

trapezoidal_rule <- function(f,a,b,n)
{
  h<-(b-a)/n #sirka intervalu
  x<- a+(b-a)*(0:(n))/n # n+1 bodu
  
  suma<-(f(x[1])+f(x[n+1]))/2
  
  if(n>1){
    suma<-suma+sum(f(x[2:n])) 
    return(suma*h)
  }
  return(sum(f(x))*h)
}


for (n in 2:20){
  A <- matrix(0, n, n)
  for (i in 1:n){
    for (j in 1:n){
      f <- function(t){return (t^(i+j-2))}
      A[i,j] = trapezoidal_rule(f, 0, 1, 10)
    }
  }
  
  b <- rowSums(A)
  
  reseni = GaussE(A, b)
  print(reseni)
}







