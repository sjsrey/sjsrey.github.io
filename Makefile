
serve:
	docker run --rm -v ${PWD}:/srv/jekyll  -p 4000:4000 sjsrey/jekyllacademic:1.1 jekyll serve
