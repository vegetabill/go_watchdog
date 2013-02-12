Go Watchdog
===========

This uses the [Go](http://www.thoughtworks-studios.com/go-continuous-delivery) event feed to check the last completion time of a green run of a particular pipeline and the longer it has been, the watchdog image will get angrier.

I use it to monitor Mingle's Green Installer pipeline.


Setup
=====

I used Ruby 1.9.3.

I use bundler to manage the dependencies so 'gem install bundler' and then 'bundle' to install the watchdog's dependencies.

To configure the pipeline, change config.yml to point to the pipeline you want the watchdog to watch. 

You can also adjust the timing of the moods.  Right now, he starts off happy, then at 2 hours becomes neutral.  At 24 hours he becomes angry and then at 36 hours he becomes enraged.

Then:

GO_USERNAME=go GO_PASSWORD=1234 ruby watchdog.db

Put http://localhost:4567/ up on an information radiator.