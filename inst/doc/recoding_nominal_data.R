## ----setup, include = FALSE---------------------------------------------------
library(qlcData)

## ----nominalData--------------------------------------------------------------
data <- data.frame(
    size = c('large','very small','small','large','very small','tiny'),
    kind = c('young male','young female','old female','old male',NA,'young female'),
    row.names = paste('obs', 1:6, sep='')
    )
data

## ----merge--------------------------------------------------------------------
# Specifying a recoding
recoding <- list(
  list(
    recodingOf = 'size',
    attribute = 'newSize',
    values = c('large','small'),
    link = c(1,2,2,2)
    )
  )
# Do the actual recoding and see the results
recode(recoding, data)

## ----mergesplit---------------------------------------------------------------
# Specifying the recoding of three different new attributes
recoding <- list(
  list(
    recodingOf = 'size',
    attribute = 'size',
    values = c('large','small'),
    link = c(1,2,2,2)
    ),
  list(
    recodingOf = 'kind',
    attribute = 'gender',
    values = c('female','male'),
    link = c(1,2,1,2)
    ),
  list(
    recodingOf = 'kind',
    attribute = 'age',
    values = c('old','young'),
    link = c(1,1,2,2)
    )
  )
# Do the recoding and show it
newdata <- recode(recoding, data)
newdata

## ----mergeattributes----------------------------------------------------------
back_recoding <- list(
  list(
    recodingOf = c('size','age'),
    attribute = 'size+age',
    values = c('largeOld','largeYoung','smallOld','smallYoung'),
    link = c(1,3,0,2,4,0,0,0,0,0)
    )
  )
recode(back_recoding, newdata)

## ----expandgrid---------------------------------------------------------------
expand.grid(c(levels(newdata$size),NA),c(levels(newdata$age),NA))

## ----yamloutput, echo = FALSE-------------------------------------------------
cat(yaml::as.yaml(write.recoding(data, attributes=list(1,c(1,2)))))

## ----mergeattributes_v2-------------------------------------------------------
back_recoding <- list(
  list(
    recodingOf = c('size','age'),
    attribute = 'size+age',
    values = c( lo = 'largeOld'
              , ly = 'largeYoung'
              , so = 'smallOld'
              , sy = 'smallYoung'
      ),
    link = c(  'small + young' = 'sy'
             , 'small + old' = 'so'
             , 'large + young' = "ly"
             , 'large + old' = 'lo'
      )
    )
  )
recode(back_recoding, newdata)

## ----shortcuts----------------------------------------------------------------
short_recoding <- list(
  # same as first example at the start of this vignette
  # using abbreviations and a different order
  list(
    r = 'size',
    a = 'newSize',
    l = c(1,2,2,2),
    v = c('large','small')
    ),
  # the same, using named linking
  list(
    r = 'size',
    a = 'newSize',
    v = list(a = 'large', b = 'small'),
    l = list(tiny = 'b', 'very small' = 'b', small = 'b', large = 'a')
    ),
  # same new attribute, but with automatically generated names
  list(
    r = 'size',
    l = c(1,2,2,2)
    ),
  # keep original attribute in column 2 of the data
  list(
    r = 2
    ),
  # add three times the first original attribute
  # senseless, but it illustrates the possibilities
  list(
    d = c(1,2)
    )
  )
recode(short_recoding, data)

## ----expand_shortcuts_notrun, eval = FALSE------------------------------------
#  read.recoding(short_recoding, file = yourFile, data = data)

## ----expand_shortcuts, echo = FALSE-------------------------------------------
meta <- list(
  title = NULL,
  author = NULL,
  date = format(Sys.time(),"%Y-%m-%d"),
  originalData = "data"
  )
recoding <- read.recoding(short_recoding, file = NULL , data = data)
outfile <- c(meta, list(recoding = recoding))
cat(yaml::as.yaml(outfile))

