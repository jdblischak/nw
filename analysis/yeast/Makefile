
all: index.html

index.html: index.Rmd exploration.html diffbind.html metagene.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

metagene.html: metagene.Rmd exploration.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

diffbind.html: diffbind.Rmd exploration.html
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

exploration.html: exploration.Rmd _output.yaml
	R --slave -e "set.seed(100);rmarkdown::render('$<')"
