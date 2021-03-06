#' Generate LaTeX subfigure code
#'
#' Generate LaTeX subfigure code for a bunch of supplied image paths,
#' subcaptions, label and subfigure layout.
#' Supports splitting the figures over several pages or using landscape layout.
#'
#' @param images        vector with full paths to images (png-files or other LaTeX-compatible format)
#'                      to be put in a LaTeX subfigure environment
#' @param subcaptions   vector with subcaptions for each subfigure
#' @param mainlabel     string with LaTeX label for the main figure environment
#'                      should be set individually if SubfigureGenerator() is called more than once from the same document
#' @param perpage       maximum number of images on one page, one A4 page fits six images with subcaptions
#' @param ncol          LaTeX subfigure is setup with ncol columns
#' @param landscape     set this to TRUE if pages are set in landscape mode
#'
#' @return a string with LaTeX code
#' @export
SubfigureGenerator <- function(images,
                               subcaptions,
                               mainlabel = "fig:mainfig",
                               perpage = 6,
                               ncol = 2,
                               landscape = FALSE) {
   # Collect all LaTeX code in a textconnection
   # that's dumped to a vector before return
   zzstring <- ""
   zz <- textConnection("zzstring", "w")

   # If landscape is TRUE, set pagewidth to \textheight
   #    pagewidth <- ifelse(landscape == TRUE, "\\textheight", "\\textwidth")
   pagewidth <- "\\textwidth"

   # Check that the vector of images is non-empty
   if (length(images) > 0) {
      # keep track of the number of pages the images are split across
      page.counter <- 1
      # Calculate width of subfigure based on ncol-value
      subfigure.width <- 1 / ncol - 0.02

      # begin figure
      if (landscape == TRUE) {
         cat("\\begin{sidewaysfigure}\\centering\n", file = zz)
      } else {
         cat("\\begin{figure}[hb]\\centering\n", file = zz)
      }

      # display images in a X-by-Y grid
      for (i in 1:length(images)) {
         cat(paste("\\begin{subfigure}[b]{", round(subfigure.width, 2),
                   pagewidth, "}\\centering\n", sep = ""), file = zz)
         # this includes the i-th image in a subfigure
         cat(paste("\\includegraphics[width=\\linewidth]{",
                   images[i], "}\n", sep = ""), file = zz)
         cat(paste("\\caption{", subcaptions[i],
                   "}\n", sep = ""), file = zz)
         cat(paste("\\label{", mainlabel, ":sfig-", int2padstr(ii = i, pchr = "0", w = 3),
                   "}\n", sep = ""), file = zz)
         cat("\\end{subfigure}", file = zz)
         #
         if (!(i %% (perpage)) && length(images) != (perpage*page.counter)) {
            cat("\\caption{Main figure caption.}\n", file = zz)
            cat(paste("\\label{", mainlabel, "-",
                      int2padstr(ii = page.counter, pchr = "0", w = 3),
                      "}\n", sep = ""), file = zz)
            if (landscape == TRUE) {
               cat("\\end{sidewaysfigure}\n", file = zz)
            } else {
               cat("\\end{figure}\n", file = zz)
            }
            cat("\n", file = zz)
            if (landscape == TRUE) {
               cat("\\begin{sidewaysfigure}\\centering\n", file = zz)
            } else {
               cat("\\begin{figure}[tb]\\centering\n", file = zz)
            }
            # Step-up page.counter
            page.counter <- page.counter + 1
         } else {
            if (i %% ncol) {
               # odd number -- add inter-column space
               cat("\\,\n", file = zz)
            }
            if (!(i %% ncol)) {
               # even number -- add newline and some vspace
               cat("\\\\[6pt]\n", file = zz)
            }
         }
      }
      #
      # end figure
      cat("\\caption{Main caption.}\n", file = zz)
      cat(paste("\\label{", mainlabel, "-",
                int2padstr(ii= page.counter, pchr = "0", w = 3),
                "}\n", sep = ""), file = zz)
      if (landscape == TRUE) {
         cat("\\end{sidewaysfigure}\n", file = zz)
      } else {
         cat("\\end{figure}\n", file = zz)
      }
   }

   zzstring <- textConnectionValue(zz)
   close(zz)
   return(zzstring)
}
