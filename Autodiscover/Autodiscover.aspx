<%@ Page Language="C#" %>
<% Response.ContentType = "text/xml";

/*
repo+gist@bananaacid.de
Nabil Redmann 2016


 Requirements:

  reachable through https://autodiscover.DOMAIN.TLD/Autodiscover/Autodiscover.aspx
  '-> add a rewrite from Autodiscover.xml to Autodiscover.aspx -> at /web.config

  I added a lot of domains (the DOMAIN.TLD part), binded to the physical path of this file. (IIS, would also work with apache aliases)

  There is no extra DNS stuff required, we have a subdomain and a path here. (There are also other methods of using the autodiscover handler.)

  Needs a valid SSL certificate for this subdomain (SSL is used in the configuration, and Outlook will reject non SSL autodiscover paths)
  -> CA Authority 'lets encrypt', and for the lets encrypt clients for IIS an empty index.html to return a response code 200

*/

// *** extract the domain name from the request
string[] s = Request.Url.Host.Split(new char[]{'.'});
Array.Reverse(s);
string newHost = s[1] + "." + s[0]; // domain.tld

// *** read all of the post data
var sr = new System.IO.StreamReader(Request.InputStream);
string content = sr.ReadToEnd();


// *** save posted XML request
using (var w = new System.IO.StreamWriter(Server.MapPath("~/Autodiscover/cache/data.txt"), true)) 
    w.WriteLine(content); // Write the text


// *** overwrite supplied username with email address for LoginName
// Android trouble ?? http://fossies.org/linux/horde-groupware/framework/ActiveSync/lib/Horde/ActiveSync/Request/Autodiscover.php
string eMail = "";
Regex re = new Regex(@"<EMailAddress>(.*)<\/EMailAddress>");
Match m = re.Match(content);
if (m.Groups.Count > 0)
	eMail = "<LoginName>" + m.Groups[1].Value + "</LoginName>";

%><?xml version="1.0" encoding="utf-8" ?>
<Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006">
	<Response xmlns="http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a">
		<Account>
			<AccountType>email</AccountType>
			<Action>settings</Action>
			<Protocol>
				<%= eMail %>
				<Type>IMAP</Type>
				<Server>imap.<%= newHost %></Server>
				<Port>993</Port>
				<DomainRequired>off</DomainRequired>
				<SPA>off</SPA>
				<SSL>on</SSL>
				<AuthRequired>on</AuthRequired>
			</Protocol>
			<Protocol>
				<%= eMail %>
				<Type>SMTP</Type>
				<Server>smtp.<%= newHost %></Server>
				<Port>465</Port>
				<DomainRequired>off</DomainRequired>
				<SPA>off</SPA>
				<SSL>on</SSL>
				<AuthRequired>on</AuthRequired>
				<UsePOPAuth>on</UsePOPAuth>
			</Protocol>
		</Account>
	</Response>
</Autodiscover>