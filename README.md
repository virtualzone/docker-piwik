# docker-piwik

Pull this respository and run `docker build -t overshard/piwik .` inside it.
It'll create a piwik ready image. From there you can run it by calling
`docker run overshard/piwik /start`. Check the port it attaches to by calling
`docker ps` and then call up your server's IP:PORT in your browser.

You then need to step through the basic configs for piwik, simply set the
database user to `root` and database to `piwik`. I haven't taken the time to
secure anything yet so use in production at your own risk!
