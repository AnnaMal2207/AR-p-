#Построить график процесса AR(1), из 𝑛 наблюдений, для различных значений параметра Teta
n = 1000
set.seed(123)
E = rnorm(n,0,1)
Teta = 0.5
Teta_2 = 0.2

#Функция,возвращающая значения AR(1) процесса для заданного значения Teta
AR = function(Teta) 
{x_1 = numeric(n) #нулевой вектор длины n.
 x_1[1] = E[1]
 for (i in 2:n){x_1[i]=Teta*x_1[i-1] + E[i]}
 return(x_1)
}
ar_1 = AR(0.5)
plot(ar_1, type='l')
#Графики для различных значений Teta
par(mfrow=c(3,1))
plot(AR(0.5), type='l', col='blue', main=paste("AR(1) (Teta=", 0.5, ")"))
plot(AR(1), type='l', col='red', main=paste("AR(1) (Teta=", 1, ")"))
plot(AR(1.5), type='l', col='purple', main=paste("AR(1) (Teta=", 1.5, ")"))

#Функция, возвращающая значения AR(1) процесса для заданного значения Teta и объёма выборки k
AR_k = function(Teta, k) 
{x_2 = numeric(k)
 x_2[1] = E[1]
 for (i in 2:k){x_2[i] = Teta*x_2[i-1] + E[i]}
 return(x_2)
}

#МНК-оценки для разных значений k
Teta_k = numeric(n-9)
for (k in 10:n) 
{y = AR_k(Teta, k)
 X = cbind(y[1:(k-1)], rep(1, k-1))
 Teta_k[k-9] = solve(t(X) %*% X) %*% t(X) %*% y[-1]
}

plot(10:n, Teta_k, type='l', col='blue', main='Оценка Teta по размеру выборки', xlab='Размер выборки', ylab='Оценка Teta')

#Оценка параметра Teta методом наименьших квадратов (МНК)
y = AR(Teta)
X = cbind(AR(Teta)[1:(n-1)], rep(1, n-1))
Teta_k = solve(t(X) %*% X) %*% t(X) %*% y[-1]; Teta_k

plot(y, type='l', col='blue', main='AR(1) процесс и регрессионная прямая')
abline(Teta_k, 0)

#Оценка максимального правдоподобия(МП) для Teta
MP = function(Teta, y) {return(-sum(dnorm(y[-1] - Teta*y[-n], log = TRUE)))}
Teta_mp = optimize(MP, interval=c(-1, 1), y=AR(Teta)); Teta_mp

MP=function(Teta)
{sum=0
for(i in 2:100){sum=sum+(ar_1[i]-Teta*ar_1[i-1])^2}
return(sum)
}
MP_1 = optimize(f= MP, interval = c(-1,1));MP_1

#График AR(1) процесса и регрессионной прямой
plot(y, type='l', col='blue', main='AR(1) процесс и оценка максимального правдоподобия')
abline(Teta_ml$minimum, 0)

#Вывод о взаимосвязи оценок МНК и МП для параметра 𝜃 в случае гауссовского шума.
#В случае гауссовского шума оценки МНК и МП для параметра 𝜃 совпадают, 
#т.к. в этом случае функция правдоподобия имеет квадратичную форму.

#МНК-оценки для разных значений k
Teta_k = numeric(n-9)
for (k in 10:n) 
  {y = AR_k(Teta, k)
   X = cbind(y[1:(k-1)], rep(1, k-1))
   Teta_k[k-9] = solve(t(X) %*% X) %*% t(X) %*% y[-1]
  }

plot(10:n, Teta_k, type='l', col='blue', main='Оценка Teta в зависимости от объёма выборки', xlab='Размер выборки', ylab='Оценка Teta')

#Построить график устойчивого процесса 𝐴𝑅(2), из 𝑛 наблюдений.
#Функция, возвращающая значения AR(2) процесса для заданных значений Teta и Teta_2
AR_2 = function(Teta, Teta_2) 
{x_2 = numeric(n)
 x_2[1:2] = E[1:2]
 for (i in 3:n) {x_2[i] = Teta * x_2[i-1] + Teta_2 * x_2[i-2] + E[i]}
 return(x_2)
}
plot(AR_2(Teta, Teta_2), col='violet',type='l', main='Процесс AR(2)')

#Вычислить значение параметра 𝐴𝑅(2), используя функцию 𝑎𝑟𝑖𝑚𝑎 пакета 𝑠𝑡𝑎𝑡𝑠.
library("stats")
p=2;d=0;q=0
arima_model = arima(AR_2(Teta, Teta_2), order=c(p,d,q),include.mean =  FALSE)
arima_model$coef

arima(AR_2(Teta, Teta_2), order=c(p,d,q),include.mean =  FALSE)
