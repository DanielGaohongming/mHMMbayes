#' @export
#'
print.mHMM <- function(x, ...){
  input   <- x$input
  n_subj  <- input$n_subj
  burn_in <- input$burn_in
  J       <- input$J
  m       <- input$m
  q_emiss <- input$q_emiss
  n_dep   <- input$n_dep
  cat("Number of subjects:", n_subj, "\n")
  cat("\n")
  cat(J, "iterations used in the MCMC algorithm with a burn in of", burn_in, "\n")
  LL      <- numeric(n_subj)
  for(i in 1:n_subj){
    LL[i] <- median(x$PD_subj[[i]][((burn_in + 1): J), (sum(q_emiss * m) + m*m + 1)])
  }
  AIC<-2*(sum((q_emiss-1)*m)+(m-1)*m) - (2*LL)
  cat("Average Log likelihood over all subjects:", mean(LL), "\n")
  cat("Average AIC over all subjects:", mean(AIC), "\n")
  cat("\n")
  cat("Number of states used:", m, "\n")
  cat("\n")
  cat("Number of dependent variables used:", n_dep, "\n")
  cat("\n")
}
