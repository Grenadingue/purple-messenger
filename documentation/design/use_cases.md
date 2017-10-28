# Use cases

The goal of this application is to replace the panacea of different messaging applications we use on our smartphone.

## Summary description
The messaging services to encapsulate are (non exhaustively):
- sms/mms
- facebook messenger
- irc (including slack)
- riot.im
- whatsapp
- google talk
- skype
- telegram
- discord

The main use case is to be able to send and receive text via this different services.

Besides sending and receiving text we should be able to send and receive emoticons, stickers and files if the used services can handle it.

Because of the ergonmy needed by a mobile application, it would be interesting to orient the user interface to focus on conversations, this leading to an interface similar to the default android messaging application, or facebook messenger, whatsapp, etc.

Beyond the goal of replacing all this applications, one interesting feature would be to let the user merge different threads from different services into one thread. Use case: Ms. Smith and I use sms + facebook + slack + riot.im to discuss together, with this feature I can merge all of this channels to receive all the messages into one thread. Then I would be able to choose from which service I want to respond.

The user must be able to be notified from requests, like new messages, new threads, incoming files. This includes to handle system's sounds, vibrations and notifications in a common way.

The user must be able to configure the behavior of the application. This includes how he wants to be notified from messaging events, and if and how some automatic behaviors should be set. This events should be handled with global rules, services rules, threads rules, and buddies rules.

The user must be able to configure the interface theme with some pre-defined themes, like light, dark, etc.
