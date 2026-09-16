#' Import all excel files in a given directory as a single dataframe
#'
#' @return a dataframe with imported data
#' @param dir name of the directory with files to import
#' @param sheet which sheet to import
#' @param pattern regexp that matches filenames to be imported
#' @export

dir = "Bjorn2026/Data"
sheet = 1
pattern = "*_SEP.xlsx"

ExcelToDF <- function(dir = ".", sheet = 1, pattern = ".xlsx") {
    filenames <- list.files(path = dir,
                            pattern = pattern,
                            full.names = TRUE)
    if (length(filenames) == 0) {
        cat("No files matching these criteria\n")
    } else if (length(filenames) == 1) {
        dfAll <- read_excel(filenames, sheet = sheet)
        return(data.frame(dfAll))
    } else {
        df.list <- lapply(filenames,
                          function(x) read_excel(path  = x,
                                                 sheet = sheet))
        dfListTrim <- lapply(df.list, `[`, 1:4)
        if (length(unique(lapply(dfListTrim, function(x) names(x)))) != 1) {
            cat("The excel files can not be merged as they are
                 not the same format. The following files are
                 selected based on your pattern:\n")
            return(filenames)
        } else { dfAll <- Reduce(function(x, y) merge(x, y, all = TRUE),
                                 dfListTrim)
        return(dfAll)
        }
    }
}


#' Convert GPS coordinates from SWEREF99 to WGS84
#'
#' @return a data frame with the same information in input, but in
#' WGS84
#' @param data dataframe or matrix with input data
#' @param Latitude Column in data that holds latitude data
#' @param Longitude Column in data that holds longitude data
GPSConvert <- function(data, Latitude, Longitude) {
    SWEREF99 <- 3006
    WGS84    <- 4326
    p1 <- sf::st_as_sf(data,
                   coords = c(Longitude, Latitude),
                   crs = SWEREF99)
    p2 <- sf::st_transform(p1, WGS84)
    p2
}

    


