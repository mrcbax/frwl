FRWL: From Russia with love
===

link to inception [Reddit thread](https://www.reddit.com/r/DataHoarder/comments/apsd7v/with_russia_going_offline_for_a_test_some_time/)

There is a survey available for those participating: [Google Form](https://goo.gl/forms/l2zbfzblneP6D6sE3)

There is also a place to submit any IPFS hashes of data you've collected: [Google Form](https://goo.gl/forms/o3vXwj4NPzODAttR2)

If you all would like a place to chat I've set up an orbit channel (IPFS based chat): [Orbit Channel](https://orbit.chat/#/channel/frwl) (Just join #frwl by clicking the channel menu in the top left. Seems hot-linking doesn't work.)

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

final logs should be compressed in the same manner in the style `final.servername.yourtimezone.tar.xz` with max compression in the hopes of saving even more space. You can join or stop at any time but please leave an IPFS hash as an issue or a pull request, I'll do my best to pin it as soon as I can. You can use this command to do the final compression:

`xz -9evv --lzma2=dict=128MiB,lc=4,lp=0,pb=2,mode=normal,nice=273,mf=bt4,depth=1024`

**Read the comments and code before proceeding.**


Current Statistics
---
It's about 14 compressed files a day or 31.5MB per day with a projected size of about 2GB of data per server for the entire 2 month long endeavor.

Guidelines
---

Your traceroute logs should have a bunch of data. but if there are a bunch of `***` next to a hop then you're behind some sort of nasty filtering firewall. Pop a hole in it to get clean data. We want hostnames not just latency. It's probably a good idea to be using a VPN for this. Use one really close to you to cut down on the hops. I highly recommend NordVPN.

Watch for updates to the script they may be important for data processing. You may have to work them into your environment somehow.

If you are editing the code tabs are 4 spaces. Don't make me write a `CONTRIBUTING.md`.


Extra stuff
---

The current shodan query for Russian NTP servers: `ntp country:"RU" port:"123"`

The deduplication script can be used so you can dump any additional IPs at the bottom of the list, then remove any duplicates.



Docker
===

Dockerfile
---

The dockerfile and the ping_russia_docker.sh script has added the arguement variable to the server declaration so that it is passed and not hard set.  `SERVER="" > SERVER="$1"`


Docker Run
---

By creating a script to create multiple containers and volumes to automate launching containers with different IPs will be able to test against many servers easily.

 An image has been provided at https://hub.docker.com/r/danuke/frwl

docker run -d --name frwl -v "localvolume":/from_russia_with_love_comp -e ServerIP="IP/Host" danukefl/frwl



Contributors
===

We <3 you!
---

- **/u/BigT905 and /u/orangejuice3 for the Shodan results! Massive contribution thank you!**

- /u/meostro: Final compression command.

- Colseph: Awesome script mods

- Danuke: for Dockerfile and image creation.

- gidoBOSSftw5731: FreeBSD support.
