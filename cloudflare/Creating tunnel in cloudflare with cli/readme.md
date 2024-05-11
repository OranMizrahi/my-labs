First you need to connect to the cloudflare and authorize your account
```
cloudflared login
```
Then a folder created in your home user directory
called .cloudflared in the directory it has a file cert.pm Privacy Enhanced Mail that you just authorize with
that contain inside this file Private Key, Certificate, Argo Tunel Token

Lets get started creating our first tunnel by writing 
```
cloudflared tunnel create {tunnel-name}
```

you need to copy the tunnelID=UUID then create a yaml file inside .cloudflare folder 

```
---
tunnel: {UUID}
credentials-file: /home/{USER}/.cloudflared/{UUID}.json
ingress:
  - hostname: tunnel.<domain>
    service: http://localhost:5000
  - service: http_status:404
```

This create the CNAME record on the DNS cloudflare 
```
cloudflared tunnel route dns {tunnel-name} test.{domain}
```
cloudflared tunnel --config {config.yaml} run {UUID}

this is the article I used
https://hkamran.medium.com/cloudflare-remote-access-home-assistant-069e50ed2570