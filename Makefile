PROJECT="TerraBrasilis.love"

all:
	@rm -f ${PROJECT}
	@echo "Collecting and adding source file..."
	@cd src/; zip -r ../${PROJECT} *

run:
	@love ${PROJECT}

clear:
	@rm ${PROJECT}
