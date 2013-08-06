```                                          
   _______  ______ _____ __________  _____
  / ___/ / / / __ `/ __ `/ ___/ __ \/ ___/
 (__  ) /_/ / /_/ / /_/ / /  / /_/ (__  ) 
/____/\__,_/\__, /\__,_/_(_)/ .___/____/  v0.1.0
           /____/          /_/            
```

A PowerShell utility module with some sweet, syntactic goodness.

## Summary

`sugar.ps` is not meant to be another "kitchen-sink" powershell utility module. It's primary goals are to make it easier to work with **core** objects in the OS (such as files and directories) and simplify the syntax for common operations. It's designed to be small, intuitive and 100% PowerShell.

## Features

`sugar.ps` provides the following handy functions (in the style of prefix operators):

* `?:` invoke ternary (shorthand if-then-else)
* `??` null coalesce
* `~>` copy files
* `=>` copy files and directory structure

## Usage

The following is a sample script to illustrate some of the features of `sugar.ps`.

```powershell
 # import the module
 import-module "path\to\sugar.psm1" -DisableNameChecking

 # determine which source folder to backup
 # (using the invoke-ternary function)
 $dow = [DateTime]::Today.DayOfWeek
 $src = ?: {$dow -eq [DayOfWeek]::Sunday} {"c:\"} {"c:\essential"}

 # copy source files and logs to the backup folder
 # (using the copy-files functions) 
 => "$src"                "d:\backups\$dow\data"
 ~> "c:\logs\**\*.log"    "d:\backups\$dow\logs"
```

## Credits

* Ternary operator code was borrowed from the [PowerShell team](http://blogs.msdn.com/b/powershell/archive/2006/12/29/dyi-ternary-operator.aspx)
* File glob pattern syntax inspired by [ANT glob patterns](http://ant.apache.org/manual/dirtasks.html#patterns)
* The 'sugar' name was inspired by [sugar.js](http://sugarjs.com/)
