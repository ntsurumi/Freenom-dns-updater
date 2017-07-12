[![Build Status](https://travis-ci.org/whatever4711/Freenom-dns-updater.svg?branch=master)](https://travis-ci.org/whatever4711/Freenom-dns-updater)

# Freenom dns updater
A tool written in python to update [freenom](http://Freenom.com)'s dns records

## Main Features
* Manage (add/update/remove) a domain's dns record with cli
* Automatic records updates according to ip (v4/v6) changes

## Upcoming features
* Auto renew domains

## Usage

### Basic usage
Let's say you want to add or update your main A/AAAA domain records *exemple.tk* with your current ip (v4/v6).
Simply type :
```
fdu record update $LOGIN $PASSWORD exemple.tk
```

Note that if you don't have a ipv6 access, the tool will detect that and will update only the A record (ipv4) of *exemple.tk*.

In order to add or update the subdomain *sub.exemple.tk*:
```
fdu record update $LOGIN $PASSWORD exemple.tk -n sub
```


### Advanced usage
If you want to update multiple (sub)domains you could call the tool for each domains.
Even better, you can create a configuration file.  
A configuration is a [YAML](https://en.wikipedia.org/wiki/YAML) file, which look like :
```YAML
login: yourlogin@somemail.domain
password: yourpassword

# list here the records you want to add/update
record:
  # the following will update both the A and AAAA records with your current ips (v4 and v6).
  # Note that if you don't have a ipv6 connection, the program'll detect it and will only update the A record (ipv4)
  - domain: test.tk

  # the following will update both your subdomain's A and AAAA records with your current ips (v4 and v6)
  - domain: test.tk
    name: mysubdomain

  # here's more advanced exemples

  # the following will update the AAAA record with a specified ipv6
  - domain: test2.tk
    name: # you can omit this line
    type: AAAA
    target: "fd2b:1c1b:3641:1cd8::" # note that you have to quote ipv6 addresses
    ttl: 24440

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: test2.tk
    name: mysubdomain
    type: A
    target: auto # you can omit this line


  # you can omit the record type and give only ipv4 or ipv6 addresses.
  - domain: test2.tk
    name: ipv6sub
    target: "fd2b:1c1b:3641:1cd8::"

  - domain: test2.tk
    name: ipv4sub
    target: "64.64.64.64"
```

In order to use such configuration, you can use the following command :
```bash
fdu update /path/to/config
```

Where */path/to/config* can be either:
- A path to a file (default location is ```/etc/freenom.yml```)
- A http url (a raw secret [gist](https://gist.githubusercontent.com/maxisoft/1b979b64e4cf5157d58d/raw/freenom.yml) for instance)

## Schedule
In order to launch regularly an update, you can launch the tool with :
```bash
fdu process -c -i -t 3600 /path/to/config
```
Where the params are :  

| param           | description                                          |
|-----------------|------------------------------------------------------|
| -c              | cache the ip and update only if there is any changes |
| -i              | ignore errors when updating                          |
| -t              | time (in second) to wait between two updates         |
| /path/to/config | a path or a url to a configuration file              |



## Docker image (multiarch)
[![](https://images.microbadger.com/badges/version/whatever4711/freenom:amd64-latest.svg)](https://microbadger.com/images/whatever4711/freenom:amd64-latest "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/whatever4711/freenom:amd64-latest.svg)](https://microbadger.com/images/whatever4711/freenom:amd64-latest "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/whatever4711/freenom:amd64-latest.svg)](https://microbadger.com/images/whatever4711/freenom:amd64-latest "Get your own commit badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/whatever4711/freenom:armhf-latest.svg)](https://microbadger.com/images/whatever4711/freenom:armhf-latest "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/whatever4711/freenom:armhf-latest.svg)](https://microbadger.com/images/whatever4711/freenom:armhf-latest "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/whatever4711/freenom:armhf-latest.svg)](https://microbadger.com/images/whatever4711/freenom:armhf-latest "Get your own commit badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/whatever4711/freenom:aarch64-latest.svg)](https://microbadger.com/images/whatever4711/freenom:aarch64-latest "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/whatever4711/freenom:aarch64-latest.svg)](https://microbadger.com/images/whatever4711/freenom:aarch64-latest "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/whatever4711/freenom:aarch64-latest.svg)](https://microbadger.com/images/whatever4711/freenom:aarch64-latest "Get your own commit badge on microbadger.com")


## Known issues
- The domain [my.freenom.com](my.freenom.com) has [SSL Chain issues](https://www.ssllabs.com/ssltest/analyze.html?d=my.freenom.com). For now this tool use a custom ``chain.pem`` to avoid ssl errors.
>>>>>>> 59e09ff8f12ef0baadfdac37b8ebbe7cf445c98f

### Start fdu
Start fdu by calling ```docker run whatever4711/freenom:amd64-latest```, which executes all previous commands inside a container.

### Docker compose

```YAML
version: '3'
services:
  freenom:
    image: whatever4711/freenom:amd64-latest
    restart: always
    volumes:
      - /your/path/to/freenom.yml:/etc/freenom.yml
    command: ["process", "-c", "-t", "3600", "/etc/freenom.yml"]
```

### Ipv6
Note that if you want to use the ipv6 functionality, you have to enable the [docker ipv6 stack](https://docs.docker.com/v1.5/articles/networking/#ipv6)
