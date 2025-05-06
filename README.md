# Personal Blog: Thai's Station

## Hi 👋

My name is Thai, I'm a DevOps Engineer and here is my personal website :D

Since I have no experience in developing frontend application, I decided to use this very handy Jekyll template: [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy).

There're 2 ways to run the website in local machine:

- Using `docker`/`podman`:
  - Make sure you have Docker or Podman with [Compose](https://docs.docker.com/compose/) feature
  - Run the following command:

    ``` bash
      # For Docker
      docker compose up -d

      # For Podman
      podman compose up -d
    ```

  - Website is available at: <http://localhost:4000>

- Building from source code:
  - Pre-requisite:
    - `ruby` >= `3.x.x`
    - `bundle` (usually installed along with `ruby`)

  - Run Jekyll server at <http://localhost:4000>:

    ```bash
    bundle exec jekyll s
    ```

  - Build static files:

    ```bash
    bundle exec jekyll b
      ```
