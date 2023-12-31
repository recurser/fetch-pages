## Notes

- I use the [httparty](https://github.com/jnunemaker/httparty) library to simplify fetching, automatically follow redirects etc.
- To mirror assets properly, we should also update URLs within the CSS. I opted not to do this in the interest of time, but it would be fairly easy to add.
- I added a `--out=path/to/output/folder/"` option to make testing with docker easier.
- There is a Github Action to run linting checks and tests. See [`.github/workflows`](https://github.com/recurser/fetch-pages/tree/main/.github/workflows).


## Questions

- The example only showed top-level domains being fetched. How should the file naming behave if a subfolder or sub-page is fetched? I've opted to use the file or folder name in that case.
- Should the script still download the file if the --metadata flag is passed? Or should it only print metadata?


## Potential improvements

- We don't currently cache downloads to avoid duplicates. This would be easy to add though by passing a cache object to each `Asset`.
- Asset fetching could be parallelized to speed it up.
- Handle timeouts.
- Update URLs within CSS files.


## Useful commands

- `make install` - install dependencies
- `make demo-fetch` - run an example of the `fetch` command
- `make demo-metadata` - run an example of the `fetch --metadata` command
- `make demo-mirror` - run an example of the `fetch --mirror` command
- `make demo-out` - run an example of the `fetch --out=tmp/` command
- `make lint` - run code linting checks
- `make test` - run tests
- `make docker` - build the docker image `daveperrett/fetch-pages-ruby:1.0.5`
- `make demo-docker` - run an example from docker


# Running the application

```bash
make docker
```

To run the demo:

```bash
make demo-docker
```

The demo will mount `~/Desktop/tmp` on your local filesystem to the output folder within the Docker container, so that you can easily browse the output.

To SSH into the image:

```bash
docker run --rm -it --entrypoint=/bin/bash daveperrett/fetch-pages-ruby:1.0.5
```

To run the image from DockerHub remotely:

```
docker run -v ~/Desktop/tmp:/app/tmp --rm -it docker.io/daveperrett/fetch-pages-ruby:1.0.5 --mirror --out=tmp/ https://www.google.com/
```
