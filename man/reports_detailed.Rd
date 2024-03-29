% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reports.R
\name{reports_detailed}
\alias{reports_detailed}
\title{Detailed report}
\usage{
reports_detailed(start, end, extra_args = list())
}
\arguments{
\item{start}{Start time}

\item{end}{End time}

\item{extra_args}{Extra arguments to be passed to the
\href{https://docs.clockify.me/#tag/Time-Entry-Report}{API}.
Example: \code{extra_args = list(rounding = TRUE)}.}
}
\value{
A data frame with detailed time entries for the specified time period.
}
\description{
Detailed report
}
\examples{
\dontrun{
report <- reports_detailed("2022-08-01", "2022-09-01")
}
}
