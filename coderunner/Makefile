
all:
	chmod +x $(CURDIR)/*.sh
	$(CURDIR)/compile.sh
	$(CURDIR)/generate.sh
	$(CURDIR)/handout.sh

clean:
	find questions -name "*.xml" -exec rm {} \;
	find questions -name "*.pdf" -exec rm {} \;

