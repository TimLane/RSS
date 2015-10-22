function Get-RSSFeed 
{
<#
.SYNOPSIS
Retrieves the headlines of an RSS feed
.DESCRIPTION
Given the URI of a blog's RSS feed, this function will retrieve the headlines of the RSS feed.
.EXAMPLE
Get-RSSFeed -uri http://www.bbc.co.uk/blogs/adamcurtis/rss
.EXAMPLE
Get-RSSFeed http://blogs.technet.com/b/markrussinovich/rss.aspx -ShowLinks
#>

[CmdletBinding()]
param
    (
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage='What is the URI of the RSS feed?')]
        [Alias('url')]
        [uri]$uri,

        [Parameter(Mandatory=$False,
        HelpMessage='Specify this if you want to see the links')]
        [Alias('links')]
        [Switch]$ShowLinks

    )

begin
        {
            $Output = @()
        }



process
        {
            [xml]$rss = Invoke-WebRequest -uri "$uri"
            
            $titles = $rss.InnerXml | Select-Xml -XPath //title | Foreach {$_.ToString()}
            $links =  $rss.InnerXml | Select-XML -XPath //link | Foreach {$_.ToString()}

                    
            if ($ShowLinks -eq $False)
                { 
                 For ($i=0; $i -le $titles.count; $i++)
                     {
                     $obj = New-Object System.Object
                     $obj | Add-Member NoteProperty Title $titles[$i]
                     $Output += $obj
                     }
                }

            else
                {
                 For ($i=0; $i -le $titles.count; $i++)
                     {
                     $obj = New-Object System.Object
                     $obj | Add-Member NoteProperty Title $titles[$i]
                     $obj | Add-Member NoteProperty Link $links[$i]
                     $Output += $obj
                     }
                }
            $Output
        }

}