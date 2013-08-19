# docker-piwik

A nice and easy way to get a Piwik instance up and running using docker. For
help on getting started with docker see the [official getting started guide][0].
For more information on Piwik and check out it's [website][1].


## Building docker-piwik

Running this will build you a docker image with the latest version of both
docker-piwik and Piwik itself.

    git clone https://github.com/overshard/docker-piwik.git
    cd docker-piwik
    docker build -t overshard/piwik .


## Running docker-piwik

Once you get the system built you'll need to run the `init` once to create your
database and collect static files. The first item in the `-v` option,
`/mnt/piwik`, is the location on the host machine you wish to store these files.
You can now run the `start` command at any time to get the whole thing running.
If you have no other websites running on your server and just want piwk then
you can also map the port `-p` directly to `80`, `-p=80:80` and it will act as
a complete server solution.

    docker run -v=/mnt/piwik:/data overshard/piwik /init
    docker run -d=true -p=10000:80 -v=/mnt/piwik:/data overshard/piwik /start

### Running for the first time

The first time you run Piwik and connect to it via HTTP you're going to have to
setup some basics. I've locked down MySQL from all outside connections so for
the database just connect using `root`, blank everything else, database name
`piwik`. Everything else, like your first site, is up to you.

### IMPORTANT NOTE: First Run

Be sure you are using the domain name to connect/setup that you are going to use
in the future. No test domain name etc, it stores this as part of the setup and
can be a pain to change later.

### Notes on the run commands

 + `-v` is the volume you are mounting `-v=host_dir:docker_dir`
 + `overshard/piwik` is simply what I called my docker build of this image
 + `-d=true` allows this to run cleanly as a daemon, remove for debugging
 + `-p` is the port it connects to, `-p=host_port:docker_port`


[0]: http://www.docker.io/gettingstarted/
[1]: http://piwik.org/

