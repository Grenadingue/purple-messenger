# Use cases

The goal of this application is to replace the panacea of different messaging applications we use on our smartphone.

## Summary description
The messaging services to encapsulate are (non exhaustively):
- sms/mms
- facebook messenger
- irc
- slack
- riot.im
- whatsapp
- google talk
- skype
- telegram
- discord

The main use case is to be able to send and receive text via this different services.

Besides sending and receiving text, multimedia content should be well integrated, like emoticons, stickers, gifs, links, sounds, etc, as soon as the used services can handle it.

Because of the ergonomics needed by a mobile application, it would be interesting to orient the user interface to focus on conversations, this leading to an interface similar to the default android messaging application, or facebook messenger, whatsapp, etc.

Beyond the goal of replacing all this applications, one interesting feature would be to let the user merge different threads from different services into one thread. Use case: Ms. Smith and I use sms + facebook + slack + riot.im to discuss together, with this feature I can merge all of this channels to receive all the messages into one thread. Then I would be able to choose from which service I want to respond.

The user must be able to be notified from events, like new messages, new threads, incoming files. This includes to handle system's sounds, vibrations and notifications in a common way.

The user must be able to configure the behavior of the application. This includes how he wants to be notified from messaging events, and if and how some automatic behaviors should be set. This events should be handled with global rules, services rules, threads rules, and buddies rules.

The user must be able to configure the interface theme with some pre-defined themes, like light, dark, etc.

## Use cases tree
* the user
  * wants to
    - configure the application's
      - general options
        - like the processus behavior
        - like the network behavior
        - like the user's interface behavior
          - like keyboard options
          - like timestamps options
          - like the notifications
            - global toast options
            - global led color options
            - global sound options
            - global vibration options
          - like theme colors
          - like audiovisual behavior
            - like auto-download
            - like auto-play
          - like non-audiovisual behavior
            - like auto-download
        - like debugging behavior
          - like log into a file
      - messaging services options
        - like binding to a new service
        - like deleting an existing service
        - like configuring an existing service
          - like muting a service
          - like service dependent options
          - like the user's interface behavior
            - like the service's specific notifications
              - toast options
              - led color options
              - sound options
              - vibration options
            - like the service's color
    * access
      - application informations
        - like the current version
        - like the changelog
        - like all the licenses included
      - service informations
        - like current service status
      - friend informations
        - like the last date seen online
        - like its status
    - use discussion threads
      - to create a new discussion
        - by choosing the desired service
        - by choosing the friends to discuss with
      - to send/receive content
        - like text messages
        - like emoticons
        - like binary files
          - like audiovisual content (images, sounds, videos)
          - like non-audiovisual content (archives, apk, ...)
      - to merge threads together
      - to unmerge threads
      - to delete threads
      - to mute threads
  * is
    - notified of new messages
      - with a toast
      - with a blinking led
      - with a sound
      - with a vibration
