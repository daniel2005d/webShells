#### web_command: Folder con shell's web
# Multiple .net Page scripts

* cmdasp.aspx: Allow execute commands from page, without use cmd.exe or powershell to prevent AV or applocker.
	* *Commands*:
		* dir: Enumerate folder and files -> dir c:\windows\system32 or dir ~
		* cat: Read specified file -> cat c:\windows\win.ini
		* download: Allow to download file -> download c:\windows\win.ini
		* run: Run executable file
		* info: Get System information
		* ipconfig
		* ping