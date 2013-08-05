```                                          
   _______  ______ _____ __________  _____
  / ___/ / / / __ `/ __ `/ ___/ __ \/ ___/
 (__  ) /_/ / /_/ / /_/ / /  / /_/ (__  ) 
/____/\__,_/\__, /\__,_/_(_)/ .___/____/  
           /____/          /_/            
```

A PowerShell utility module with some sweet, syntactic goodness.

## Features

sugar.ps provides the following handy functions:

* `?:` (ternary pseudo-operator)
* `~>` (copy files function)
* `=>` (copy files and directory structure function)

## Usage

The following is a sample script to illustrate some of the features of sugar.ps.

    # import the module
    import-module "path\to\sugar.psm1" -DisableNameChecking

    # determine which source folder to backup
    $dow = [DateTime]::Today.DayOfWeek
    $src = ?: {$dow -eq [DayOfWeek]::Sunday} {"c:\"} {"c:\essential"}

    # copy source files and logs to the backup folder
    => "$src"                "d:\backups\$dow\data"
    ~> "c:\logs\**\*.log"    "d:\backups\$dow\logs"

## Credits

* Ternary operator code was borrowed from the [PowerShell team](http://blogs.msdn.com/b/powershell/archive/2006/12/29/dyi-ternary-operator.aspx)
* File glob pattern syntax inspired by [ANT glob patterns](http://ant.apache.org/manual/dirtasks.html#patterns)
