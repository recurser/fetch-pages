## Notes

- I use the [httparty](https://github.com/jnunemaker/httparty) in Ruby to simplify fetching, automatically follow redirects etc.
- To mirror assets properly, we should also update URLs within the CSS. I opted not to do this in the interest of time, but it would be fairly easy to add.


## Questions

- The example only showed top-level domains being fetched. How should the file naming behave if a subfolder or sub-page is fetched? I've opted to use the file or folder name in that case.
- Should the script still download the file if the --metadata flag is passed? Or should it only print metadata?


## Ruby implementation

- `make install` - to install dependencies
- `make demo-fetch` - run an example of the `fetch` command
- `make demo-metadata` - run an example of the `fetch --metadata` command
- `make demo-mirror` - run an example of the `fetch --mirror` command
- `make lint` - run code linting checks
- `make test` - run tests
