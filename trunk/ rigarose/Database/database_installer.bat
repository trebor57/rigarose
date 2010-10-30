@echo off

REM ############################################
REM ## You can change here your own DB params ##
REM ############################################
REM MYSQL BIN PATH
set mysqlBinPath=C:\Program Files\MySQL\MySQL Server 5.1\bin

set user=root
set pass=wipme004201
set db=roseon
set host=localhost

REM ############################################

set mysqldumpPath="%mysqlBinPath%\mysqldump"
set mysqlPath="%mysqlBinPath%\mysql"







REM DONT TOUCH BELOW!
REM ############################################
REM ############################################

echo PLEASE EDIT THIS SCRIPT SO VALUES IN THE CONFIG SECTION MATCH YOUR DATABASE(S)
echo.
echo.
echo Making a backup of the original database.
%mysqldumpPath% --add-drop-table -h %host% -u %user% --password=%pass% %db% > osrose_backup.sql
echo.
echo WARNING: A full install (f) will destroy data in your
echo          accounts,characters,items,quest_data and storage tables.
echo          Choose upgrade (u) if you already have a running server

:ask
set askprompt=x
set /p askprompt=DB install type: (f) full or (u) upgrade or {s} skip or (q) quit? 
if /i %askprompt%==f goto install
if /i %askprompt%==u goto upgrade
if /i %askprompt%==q goto end
goto ask

:install
echo Deleting database tables for new content.
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < full_install.sql
echo creating accounts table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < accounts.sql
echo creating channels tables
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < channels.sql
echo creating characters table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < characters.sql
echo creating items table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < items.sql
echo creating list_clans table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_clan.sql
echo creating list_friend table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_friend.sql
echo creating list_quest_qsd table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_quest_qsd.sql
echo creating list_mobgroups table !!! THIS CAN BE VERY LONG !!!
echo Note: !!! THIS CAN BE VERY LONG !!!
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_mobgroups.sql
echo creating list_mobgroups_special table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_mobgroups_special.sql
echo creating list_config table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% <list_config.sql
echo creating list_objects.sql table
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% <list_objects.sql

:upgrade
echo Installing new database content.
echo updating list_mobgroups
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_mobgroups.sql
echo updating list_npcs
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_npcs.sql
echo updating list_objects
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_objects.sql
echo updating list_telegates
%mysqlPath% -h %host% -u %user% --password=%pass% -D %db% < list_telegates.sql

:end
echo.
echo Script complete.
pause