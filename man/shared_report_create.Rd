% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reports-shared.R
\name{shared_report_create}
\alias{shared_report_create}
\title{Create a shared report}
\usage{
shared_report_create(name, start, end, is_public = TRUE, fixed_date = FALSE)
}
\arguments{
\item{name}{Name of the report}

\item{start}{Start time}

\item{end}{End time}

\item{is_public}{Is this a public report?}

\item{fixed_date}{Are the dates fixed?}
}
\description{
Create a shared report
}
\examples{
\dontrun{
shared_report_create("Sample Report", "2022-03-01", "2022-04-01")
}
}
