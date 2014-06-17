Go Watchdog
===========

This uses the awesome open-source build and deploy server, [Go](http://www.go.cd), and its event feed to check the last completion time of a green run of a particular pipeline. The longer it has been since a green build, the angrier the watchdog will appear.

I use it to monitor [Mingle's](http://getmingle.io) last deploy to staging pipeline.


Setup
=====

    > rvm use --create 1.9.3@go_watchdog

    > gem install bundler

    > bundle

    > mv config.yml{.example,}

To configure the pipeline, change config.yml to point to the pipeline you want the watchdog to watch.

You can also adjust the timing of the moods.  Right now, he starts off happy, then at 2 hours becomes neutral.  At 24 hours he becomes angry and then at 36 hours he becomes enraged.

Then to fire it up:

    > GO_USERNAME=go GO_PASSWORD=1234 rackup -p 4567

Put [http://localhost:4567/](http://localhost:4567/) up on an information radiator.

If things aren't what they seem, try deleting the .go_watchdog_cache file.