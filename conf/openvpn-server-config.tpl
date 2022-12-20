dev {{ .Dev }}
proto {{ .Proto }}
port {{ .Port }}

ca {{ .Ca }}
cert {{ .Cert }}
key {{ .Key }}
dh {{ .Dh }}
ecdh-curve prime256v1

topology subnet
{{ .Server }}
ifconfig-pool-persist {{ .IfconfigPoolPersist }}
{{ .DNSServerOne }}
{{ .DNSServerTwo }}

keepalive {{ .Keepalive }}
remote-cert-tls client
tls-version-min 1.2
tls-crypt {{ .CCEncryption }}
cipher {{ .Cipher }}
auth {{ .Auth }}

persist-key
persist-tun
crl-verify /etc/openvpn/crl.pem

log /etc/openvpn/openvpn.log
verb 3
mute 10

{{ .ExtraServerOptions }}

management {{ .Management }}
