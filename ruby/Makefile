clean:
	find . -iname "*.html" -exec rm {} \;

format:
	bundle exec rubocop --autocorrect

lint:
	bundle exec rubocop

test-run:
	bundle exec ./fetch https://www.google.com
