
all: index.html

index.html: index.Rmd exploration.html differential-expression.html go.html hox.html pluripotency.html mahony2011.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

hox.html: hox.Rmd differential-expression.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

pluripotency.html: pluripotency.Rmd differential-expression.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

mahony2011.html: mahony2011.Rmd differential-expression.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

go.html: go.Rmd differential-expression.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

differential-expression.html: differential-expression.Rmd exploration.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

exploration.html: exploration.Rmd _output.yaml
	R --slave -e "set.seed(100);rmarkdown::render('$<')"
