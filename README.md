# 🌊 Ocean

*Bring Docker Compose services to the shell*

Ocean is a proof-of-concept tool that enables the use of Compose services directly from the shell.
Essentially, instead of calling a service like this:

```sh
docker compose run --rm myservice <command>
```

Ocean enables calling it like a "native" program:
```sh
myservice <command>
```

## ❓ Context

I'm using Docker Compose for development purposes trough a Compose file that
defines a bunch of what I call *interactive* services. These are basically a
way to quickly use programs in the Docker context. For example, in a Ruby
on Rails project, my Compose file may contain the following:

```yml
  # Use Rails commands.
  #
  # Usage: docker compose run --rm rails [arguments]
  #
  # Examples: docker compose run --rm rails console
  #           docker compose run --rm rails db:create db:migrate
  rails:
    build: .
    depends_on:
      - postgres
    entrypoint: bin/rails
    profiles:
      - interactive
```

Typing `docker compose run --rm rails` is, of course, extremely not practical
and it's easy enough to setup aliases

```sh
alias dcr="docker compose run --rm"
```

So that running the Rails CLI becomes

```sh
dcr rails <command>
```

But I was wondering if I could go further and just type in `rails` and it would
automatically run Rails in a Docker container if I was in a directorycontaining
the appropriate Docker Compose file. Ocean is the anwser to that question.

## 🤔 How does it work?

Ocean sets up shims for your services in `~/.ocean/shims`. By prepending this directory to the PATH,
Ocean intercepts the command execution, determines if there is a Compose file to be used and exec
the command either via Docker if there is a Compose file in the current directory with the
appropriate service defined or via the first executable it finds in the rest of the PATH.

## 🔨 Installation & setup

First, you'll need a Ruby interpreter. If you haven't already, the Ruby version
offered via your package manager of choice should do the job. For Debian and derivatives:

```sh
sudo apt install ruby
```

Clone the repo, build and install the gem:
```sh
git clone https://github.com/durierem/ocean
cd ocean
gem build ocean.gemspec
gem install ocean-cli-0.1.0.gem
```

Then, initialize Ocean with:
```sh
ocean init
```

**And finally, add `~/.ocean/shims` to your PATH environement variable**

Now you're ready to take the sea:
```sh
ocean up serviceA serviceB
```

Now `serviceA` and `serviceB` can be invoked directly!

In order to stop shimming:
```sh
ocean down serviceA
```

## ⚠️ Limits & considerations

As its current POC state, there's a few things to point out:
- Shims are global, meaning that `which <command>` returns the shim path whether you're in a directory that contains a Compose file or not
- Ruby is not the speediest language, depending on your machine, expect up to 100ms of delay for commands to start
- The Compose file must be named "docker-compose.yml"
- It is not shell aware, meaning that, among other things, the PATH must be manually modified and  if the native command is not found, you get a Ruby error instead of your shell's traditional "command not found"
- The feature set is limited

## 💭 Footnotes

Thanks to [rbenv](https://github.com/rbenv/rbenv) for introducing me on the concept of shims.

If you're interested in Dockerized development and you're a Rails developer, check out the [Evil Martian's
article "Ruby on Whales"](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
that exposes and digs deep into how to build such setups.

It ends up introducing [dip](https://github.com/bibendi/dip) which fills a role similar to Ocean
whilst being far more mature and production ready.

These are the sources of inspiration behind Ocean.

Why is it named Ocean? I don't know, I just think it's neat :)
