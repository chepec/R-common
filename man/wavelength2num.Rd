% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/unit-converters.R
\name{wavelength2num}
\alias{wavelength2num}
\title{Convert wavelength to wavenumber}
\usage{
wavelength2num(wavelength)
}
\arguments{
\item{wavelength}{number or vector of numbers}
}
\value{
number or vector
}
\description{
Converts wavelength (nm) to wavenumber (cm-1)
Only valid for absolute wavelengths, NOT delta wavelengths (ranges)
http://www.powerstream.com/inverse-cm.htm
}
