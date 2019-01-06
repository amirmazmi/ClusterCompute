#
#   Sampole running parallel package
#   http://digitheadslabnotebook.blogspot.com/2012/12/r-in-cloud.html
#
#
#

library(pacman)
p_load(parallel, lubridate, expm)


# ######## TEST ssh connection
# wawa <- paste("ssh hepi",
#                 "\"Rscript -e 'mean(seq(10))'",
#                 "\"")
# system(wawa)

#### This setting works
primary <-  #master node
slave <- #slave node
spec <- ( list( list(host= primary, user='speedy'),
                list(host=primary, user='speedy'),
                list(host=primary, user='speedy'),
                list(host=slave, user='speedy'),
                list(host=slave, user='speedy'),
                list(host=slave, user='speedy')
        ))

cl <- makeCluster( type='PSOCK', spec=spec, master=primary,
                   timeout=600, server=F)

clusterEvalQ( cl, { library(expm) } )

## do something once on each worker
# ans <- clusterEvalQ(cl, { mean( rnorm(10E6))} )

lslen <- seq(1E3) #2E6

# harder problem
startime <- now()
ans <- parLapply( cl, lslen , function(x){matrix(seq(100), nrow=10)%^%x})
endtime <- now()
rm(ans)

start1 <- now()
ans1 <- lapply( lslen, function(x){matrix(seq(100), nrow=10)%^%x})
end1 <- now()
rm(ans1)

cat("\n [+] For parLapply:", difftime(endtime,startime, units="secs"),"seconds\n")
cat("\n [+] For lapply:", difftime(end1,start1,units="secs"),"seconds\n")
cat("\n [+] Total time:", difftime( end1, startime, units="secs"), "seconds\n" )





stopCluster(cl)
closeAllConnections()




