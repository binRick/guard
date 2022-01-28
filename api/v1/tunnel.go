package v1

import (
	"io"
	"strings"
	"text/template"

	"github.com/pkg/errors"
)

const confFmt = `[Interface]
PrivateKey = {{.PrivateKey}}
{{if .ListenPort}}ListenPort = {{.ListenPort}}{{end}}
Address = {{.Address}}
{{if .DNS }}DNS = {{.DNS}}{{end}}
{{if .Masquerade}}
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o {{.Masquerade.Interface}} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o {{.Masquerade.Interface}} -j MASQUERADE
{{end}}
{{range $peer := .Peers -}}
# {{$peer.ID}}
[Peer]
PublicKey = {{$peer.PublicKey}}
AllowedIPs = {{joinIPs $peer.AllowedIPs}}
{{if .Endpoint}}Endpoint = {{.Endpoint}}{{end}}
{{if .PersistentKeepalive}}PersistentKeepalive = {{.PersistentKeepalive}}{{end}}
{{end}}
{{if .Masquerade}}
# Masq
{{else}}
# no Masq
{{end}}
`

func (t *Tunnel) Render(w io.Writer) error {
	tmp, err := template.New("wireguard").Funcs(template.FuncMap{
		"joinIPs": joinIPs,
		"Masquerade": true,
	}).Parse(confFmt)
	if err != nil {
		return errors.Wrap(err, "parse template")
	}
	if err := tmp.Execute(w, t); err != nil {
		return errors.Wrap(err, "execute template")
	}
	return nil
}

func joinIPs(ips []string) string {
	return strings.Join(ips, ", ")
}
