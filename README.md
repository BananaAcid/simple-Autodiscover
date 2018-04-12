# simple-Autodiscover
autodiscover for Outlook, working with hMailServer (and other IMAP, SMTP connections) in C# as ASPX on IIS like it would with Exchange.

A subdomain `autodiscover` must be pointing to this folder !

The subfolder structure is required.

A SSL certificate is required to keep Outlook from complaining.

Note: a SSL certificate with SAN is fine, but the domain used for the subdomain `autodiscover` MUST be the CN / must be the primary domain the certificate is registered to. All others can be `DNS-Name` - the SANs.

Let's Encrypt Authority certificates work just fine.

for Apache + PHP: It just works the same. Just rewrite the URL and generate the simple XML snippet.