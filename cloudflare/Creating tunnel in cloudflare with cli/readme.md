
cloudflared tunnel create {tunnel-name}

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
cloudflared tunnel --config {config.yaml} run d6231727-42de-4e10-9a1e-36ecd30797ce

this is the article I used
https://hkamran.medium.com/cloudflare-remote-access-home-assistant-069e50ed2570