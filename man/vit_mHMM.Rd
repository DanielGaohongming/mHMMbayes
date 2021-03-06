% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vit_mHMM.R
\name{vit_mHMM}
\alias{vit_mHMM}
\title{Obtain hidden state sequence for each subject using the Viterbi
algorithm}
\usage{
vit_mHMM(object, s_data, burn_in = NULL)
}
\arguments{
\item{object}{An object of class \code{mHMM}, generated by the function
\code{\link{mHMM}}.}

\item{s_data}{A matrix containing the observations to be modelled, where the
rows represent the observations over time. In \code{s_data}, the first
column indicates subject id number. Hence, the id number is repeated over
rows equal to the number of observations for that subject. The subsequent
columns contain the dependent variable(s). Note that the dependent
variables have to be numeric, i.e., they cannot be a (set of) factor
variable(s). The total number of rows are equal to the sum over the number
of observations of each subject, and the number of columns are equal to the
number of dependent variables (\code{n_dep}) + 1. The number of
observations can vary over subjects.}

\item{burn_in}{The number of iterations to be discarded from the MCMC
algorithm when inferring the transition probability matrix gamma and the
emission distribution of (each of) the dependent variable(s) for each
subject from \code{s_data}. If omitted, defaults to \code{NULL} and
\code{burn_in} specified at the function \code{mHMM} will be used.}
}
\value{
The function \code{vit_mHMM} returns a matrix containing the most
  likely state at each point in time. Each column represents a subject, and
  each row represents a point in time. If sequence lengths differ over
  subjects, states for none existing time points for subjects are filled with
  \code{NA}.
}
\description{
\code{vit_mHMM} obtains the most likely state sequence for each subject from
an object of class \code{mHMM} (generated by the function \code{mHMM}),
using (an extended version of) the Viterbi algorithm. This is also known as
global decoding.
}
\details{
Note that local decoding is also possible, by inferring the most frequent
state at each point in time for each subject from the sampled state path at
each iteration of the MCMC algorithm. This information is contained in the
output object \code{return_path} of the function \code{mHMM}.
}
\examples{
###### Example on package example data
###### First fit the multilevel HMM on the nonverbal data
\donttest{
# specifying general model properties:
m <- 2
n_dep <- 4
q_emiss <- c(3, 2, 3, 2)

# specifying starting values
start_TM <- diag(.8, m)
start_TM[lower.tri(start_TM) | upper.tri(start_TM)] <- .2
start_EM <- list(matrix(c(0.05, 0.90, 0.05, 0.90, 0.05, 0.05), byrow = TRUE,
                        nrow = m, ncol = q_emiss[1]), # vocalizing patient
                 matrix(c(0.1, 0.9, 0.1, 0.9), byrow = TRUE, nrow = m,
                        ncol = q_emiss[2]), # looking patient
                 matrix(c(0.90, 0.05, 0.05, 0.05, 0.90, 0.05), byrow = TRUE,
                        nrow = m, ncol = q_emiss[3]), # vocalizing therapist
                 matrix(c(0.1, 0.9, 0.1, 0.9), byrow = TRUE, nrow = m,
                        ncol = q_emiss[4])) # looking therapist

# Fit the multilevel HMM model:
# Note that for reasons of running time, J is set at a ridiculous low value.
# One would typically use a number of iterations J of at least 1000,
# and a burn_in of 200.
out_2st <- mHMM(s_data = nonverbal, gen = list(m = m, n_dep = n_dep,
                q_emiss = q_emiss), start_val = c(list(start_TM), start_EM),
                mcmc = list(J = 3, burn_in = 1))

###### obtain the most likely state sequence with the Viterbi algorithm
states <- vit_mHMM(s_data = nonverbal, object = out_2st)
}
###### Example on simulated data
# Simulate data for 10 subjects with each 100 observations:
n_t <- 100
n <- 10
m <- 2
q_emiss <- 3
gamma <- matrix(c(0.8, 0.2,
                  0.3, 0.7), ncol = m, byrow = TRUE)
emiss_distr <- matrix(c(0.5, 0.5, 0.0,
                        0.1, 0.1, 0.8), nrow = m, ncol = q_emiss, byrow = TRUE)
data1 <- sim_mHMM(n_t = n_t, n = n, m = m, q_emiss = q_emiss, gamma = gamma,
                  emiss_distr = emiss_distr, var_gamma = .5, var_emiss = .5)

# Specify remaining required analysis input (for the example, we use simulation
# input as starting values):
n_dep <- 1
q_emiss <- 3

# Fit the model on the simulated data:
# Note that for reasons of running time, J is set at a ridiculous low value.
# One would typically use a number of iterations J of at least 1000,
# and a burn_in of 200.
out_2st_sim <- mHMM(s_data = data1$obs,
                 gen = list(m = m, n_dep = n_dep, q_emiss = q_emiss),
                 start_val = list(gamma, emiss_distr),
                 mcmc = list(J = 11, burn_in = 5))

###### obtain the most likely state sequence with the Viterbi algorithm
states <- vit_mHMM(s_data = data1$obs, object = out_2st_sim)


}
\references{
\insertRef{viterbi1967}{mHMMbayes}

 \insertRef{rabiner1989}{mHMMbayes}
}
\seealso{
\code{\link{mHMM}} for analyzing multilevel hidden Markov data
  and obtaining the input needed for \code{vit_mHMM}, and
  \code{\link{sim_mHMM}} for simulating multilevel hidden Markov data.
}
