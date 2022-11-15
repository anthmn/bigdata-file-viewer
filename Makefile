NAME := bigdata-file-viewer
VERSION := $(shell cat pom.xml | grep '^  <version>' | cut -d '>' -f 2 | cut -d '<' -f 1)
JAR := BigdataFileViewer-$(VERSION)-jar-with-dependencies.jar
BUILDDIR := target
DEBDIR := $(NAME)-$(VERSION)

.PHONY: all
all:
	mvn package -Pjava11

.PHONY: deb
deb:
	mkdir $(DEBDIR)
	cp -r debian/* $(DEBDIR)/
	cp $(BUILDDIR)/$(JAR) $(DEBDIR)/usr/share/$(NAME)/
	sed -i 's/{{{name}}}/$(NAME)/g' $(DEBDIR)/DEBIAN/control
	sed -i 's/{{{version}}}/$(VERSION)/g' $(DEBDIR)/DEBIAN/control
	sed -i 's/{{{jar}}}/$(JAR)/g' $(DEBDIR)/usr/share/$(NAME)/$(NAME)
	dpkg-deb --build $(DEBDIR)

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)
	rm -rf $(DEBDIR)
