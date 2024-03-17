local:
	bundle exec jekyll s

bbuild:
	JEKYLL_ENV=production bundle exec jekyll b

fbuild:
	env JEKYLL_ENV production; bundle exec jekyll b
