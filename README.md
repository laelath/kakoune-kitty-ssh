I have found a much better way to achieve this behavior using socat
`socat unix-listen:/tmp/kakoune/$USER/$2,fork exec:'ssh '$1' "socat - unix-connect:/tmp/kakoune/$USER/'$2'"'`
Where `$1` is the ssh options, and `$2` is the kakoune socket to connect to.

# kakoune-kitty-ssh
A kakoune plugin that utilizes kitty's ability to run remote control calls from an ssh server.

## Setup
Add `kitty-ssh.kak` to your autoload or source it manually.

## Usage
Call `new`, `new-tab`, or `repl` when using kakoune on an ssh server.
