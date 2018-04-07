# cmd-alias
alias command for command prompt
	
	ALIAS.CMD
	Requires Microsoft's DOSKEY
	https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/doskey

# alias.cmd install location
	
	Place the alias.cmd file in a PATH folder
	You CAN put it in the %windir% if you would like, however I personally put it
	in my C:\Shell folder which also has its own ENV called %Shell% which is also
	in my PATH, just as an example.

# In-command help reads as follows:
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
