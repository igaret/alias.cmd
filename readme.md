Alias command addon for CMD written in BATCH
	Requires Microsoft's DOSKEY
	https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/doskey

In-command help reads as follows:

ALIAS
	-h --help or /?
	
	Creates a custom command, or shorthand nickname for available commands.
	Similar to the bash command "alias" with a notable exception...
		Single quotes around the custom command are not required.
			For example:
				alias ls='ls -A --color=always'
			Becomes...
				alias ls=ls -A --color=always
		
	Usage:
		ALIAS [alias]=[command]
			[alias]			specifies a name for an alias you create.
			[command]		specifies the triggered command(s).

 		To clear an alias, make its definition blank
			Example:
				alias ls=

	Special alias definitions:
		$t     			Command separator.
		$1-$9  			Arguments for batch variables
		$*     			Arguments for batch parameters
		Example:
			alias google=start "" /b "http://www.google.com/search?q=$*"

	Alias save files are stored in:
		%userprofile%\Doskey-Aliases AKA C:\User\Name\Doskey-Aliases

	-h --help or /?
		Will bring up this help