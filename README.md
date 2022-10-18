# Private Events
## Project Description
This app is meant to allow users to create (host) events, and register for events hosted by other users. Conceptually, it can be thought of as a lightweight, barebones version of a site like [Eventbrite](https://www.eventbrite.com/).

This project is part of The Odin Project's Ruby on Rails curriculum; its specific focus is to provide practice for using ActiveRecord's powerful Associations. You can review the project outline [here](https://www.theodinproject.com/lessons/ruby-on-rails-private-events).

There is currently a bug which I am aware of, but have not found a solution to - daylight savings are not accounted for. 
For example, if a user's saved time zone is GMT-5, but daylight savings is active (GMT-4), all event times will be offset by one hour.
