Go Watchdog
===========

This information radiator watches the event feed for the awesome open-source build and deploy server, [Go.CD](http://www.go.cd).  The longer it has been since a green build, the angrier the watchdog will appear.

![The watchdog in action](example.png "Go Watchdog watching over Mingle's deployment pipeline. He's happy, for now...")

I use it to monitor [Mingle's](http://getmingle.io) last deploy to staging pipeline.


Setup
=====

This assumes you're using [rbenv](https://github.com/sstephenson/rbenv)

    > gem install bundler

    > bundle

    > cp config.yml{.example,}

To configure the pipeline, change config.yml to point to the pipeline you want the watchdog to watch.

You can also adjust the timing of the moods.  Right now, he starts off happy, then at 2 hours becomes neutral.  At 24 hours he becomes angry and then at 36 hours he becomes enraged.

Then to fire it up:

    > GO_USERNAME=go GO_PASSWORD=1234 rackup -p 4567

Put [http://localhost:4567/](http://localhost:4567/) up on an information radiator.

If things aren't what they seem, try deleting the .go_watchdog_cache file.
