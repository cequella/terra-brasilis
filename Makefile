PROJECT="TerraBrasilis.love"

all:
	@echo "Collecting and adding source file..."
	@zip ${PROJECT} -r -j src/main.lua

play:
	@love ${PROJECT}

clear:
	@rm ${PROJECT}
