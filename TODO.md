# ToDo

This is a roadmap and a ToDo list for contash. If you want to contibute, post an issue and I'll put it on the list…

1. Internal functions
  - hook to Contaos backend to be able to run Contao system functions such as the `InstallTool`, `PurgeData`, `CronJob` or what ever
  - drop DOCUMENTROOT in favor for current directory or some other directory provided as a parameter
      - **check** for `pathconfig.php`!
  - establish a usage like `contash [options] <command> [args]`
  - local archive of previously downloaded versions (path in config file)
  - create folders named $PROJECT in /files and /templates 
  - initiate git repository in /

2. Options
  - create a help message invoked `contash -h` or `contash --help`
  - option `-v 3.2.10` or `--version=3.3.0` to install a specific version. If omitted install latest stable
  - option `-i` or `--import=[editor|db.sql]` to import a usergroup *editor* or given sql-file 
  - option `-l` or `--alllangs` to keep all language files in system/modules/core/languages. If omitted delete all but de & en
