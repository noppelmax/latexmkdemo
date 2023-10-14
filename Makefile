## Encoding: UTF-8 ##

MASTER = 2022-sok-attacking-explanations
ZIPNAME = presentation.zip
.PHONY: clean

TABLESCSV = "tables"
TABLEFILES = $(wildcard tables/*.ods)

$(TABLESCSV)/%.csv: $(TABLEFILES)
	mkdir -p $(TABLESCSV)
	libreoffice --headless --convert-to csv $? --outdir $(TABLESCSV)
	
tables : $(TABLESCSV)/*.csv
	python src/preprocess_csv.py $? --inplace
	#sed -i 's/"//g' $?


