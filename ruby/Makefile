clean:
	find . -iname "*.html" -exec rm {} \;
	find . -type d -iname "*-assets" -prune -exec rm -rf {} \;

demo-fetch: clean
	bundle exec ./fetch https://www.google.com https://autify.com

demo-metadata:
	bundle exec ./fetch --metadata https://www.google.com https://autify.com

demo-mirror:
	bundle exec ./fetch --mirror https://www.daveperrett.com

format:
	bundle exec rubocop --autocorrect

install:
	bundle install

lint:
	bundle exec rubocop

test:
	bundle exec rspec spec/
