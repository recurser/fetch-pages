clean:
	find . -iname "*.html" -exec rm {} \;
	find . -type d -iname "*-assets" -prune -exec rm -rf {} \;

demo-docker: docker
	docker run -v ~/Desktop/tmp:/app/tmp --rm -it daveperrett/fetch-pages-ruby:1.0.5 --mirror --out=tmp/ https://www.google.com/

demo-fetch: clean
	bundle exec ./fetch https://www.google.com https://autify.com

demo-metadata:
	bundle exec ./fetch --metadata https://www.google.com https://autify.com

demo-mirror:
	bundle exec ./fetch --mirror https://www.daveperrett.com

demo-out:
	bundle exec ./fetch --mirror --out=tmp/ https://www.daveperrett.com

docker:
	docker build -t daveperrett/fetch-pages-ruby:1.0.5 .

format:
	bundle exec rubocop --autocorrect

install:
	bundle install

lint:
	bundle exec rubocop

test:
	bundle exec rspec spec/
