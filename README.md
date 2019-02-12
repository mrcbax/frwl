From Russia with love
===

Goals
---

- Figure out when the shutdown happens, as well as when everything comes back up. Currently all we know is "before April 1st 2019" that's not good enough.
- Be the first to identify the new "great firewall" infrastructure.
- Keep it decentralized, they can't hack everyone if they get angry.
- Find news and articles to corroborate our findings.
- Keep it running up to a week after Russia comes back online.
- Run some pretty data analysis on it later.


How it do?
---

We will be tracerouting the most nuclear servers I could think of. NTP servers. You can find them on shodan or use this list I've gathered `servers.txt`.

Currently a shell script. Improvements welcome as pull requests.

Data will be hosted on IPFS. The data gets packaged into txz by the shell script as 50MB uncompressed chunks (about 2.3MB max compressed). The data is just the output of a traceroute. When its all done IPFS hashes of your data can be submitted here as pull requests appended to the `hashes.txt` file. Don't forget to add your name to the bottom of this readme if you contribute!

The script creates logs in a weird way. Each file has a unique ID in the set and each set has a unique ID as well. The logs end in either `.new` or `.old` this allows me to use diff tools a little easier.

Read the comments and code before proceeding.


Guidelines
---

Your traceroute logs should have a bunch of data. but if there are a bunch of `***` next to a hop then you're behind some sort of nasty filtering firewall. Pop a hole in it to get clean data. We want hostnames not just latency. It's probably a good idea to be using a VPN for this. Use one really close to you to cut down on the hops. I highly recommend NordVPN.


Extra stuff
---

The current shodan query for Russian NTP servers: `ntp country:"RU" port:"123"`


Contributors
===

We <3 you!
---

There's nobody here :(
