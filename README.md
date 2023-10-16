## fetch-pages

See the [ruby](https://github.com/recurser/fetch-pages/tree/main/ruby) implementation and associated [README](https://github.com/recurser/fetch-pages/blob/main/ruby/README.md).

I have also built a release pipeline which uses Github Actions to tag and pushes images to DockerHub when the `main` branch is merged into `production`.

- See the list of [releases on Github](https://github.com/recurser/fetch-pages/releases)
- See the list of [images on DockerHub](https://hub.docker.com/repository/docker/daveperrett/fetch-pages-ruby/general)
- The release process uses [semantic-release](https://github.com/semantic-release/semantic-release) for automated tagging. Another good option for this is Google's [release-please](https://github.com/googleapis/release-please)
