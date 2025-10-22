SHELL=bash

REFS=$(shell cat assets/referenced_publications.txt assets/futuresdr_publications.txt | sort | uniq | sed -e 's/^/cache\//g'  | sed -e 's/$$/-ref.shtml/g')

.PHONY: publications
publications: ${REFS}

%.shtml:
	mkdir -p ./cache
	$(eval FILE=$(shell echo $@ | sed -e 's/cache\///g'))
	echo ${FILE}
	cp /home/basti/src/blog/bib/inc/${FILE} ./cache/
	perl -p -i -e "s#href=\"/#href=\"https://www.bastibl.net/#g" $@
	perl -p -i -e "s#src=\"/#src=\"https://www.bastibl.net/#g" $@

.PHOHY: upload
upload:
	zola build
	rsync -az --progress -e ssh --delete --exclude 'learn/' dist/ basti@fleark.de:/srv/www/futuresdr.org/
