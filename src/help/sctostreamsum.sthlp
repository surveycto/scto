{smcl}
{* 19 Oct 2018}{...}
{hline}
help for {hi:sctostreamsum}
{hline}

{title:Title}

{phang2}{cmdab:sctostreamsum} {hline 2} This command calculates statistics from sensor stream files outputted during data collection using {browse "https://www.surveycto.com/":SurveyCTO} and summarize them on submission level in a .dta file so that they can be merged with the main data.

{title:Syntax}

{phang2} {cmdab:sctostreamsum} ,
		{cmdab:media:folder(}{it:folder_path}{cmd:)} {cmdab:output:folder(}{it:folder_path}{cmd:)}
	[
		{cmdab:sen:sors(}{it:string}{cmd:)} {cmdab:replace} {cmdab:quiet} {cmdab:still} {cmdab:moving}
		{cmdab:llbet:ween(}{it:string}{cmd:)} {cmdab:slbet:ween(}{it:string}{cmd:)}
		{cmdab:spbet:ween(}{it:string}{cmd:)} {cmdab:mvbet:ween(}{it:string}{cmd:)}
	]{p_end}

{marker opts}{...}
{synoptset 24}{...}
{synopthdr:options}
{synoptline}
{pstd}{it:Required options:}{p_end}
{synopt :{cmdab:media:folder(}{it:folder_path}{cmd:)}} Folder where the csv stream files used as an input to this command is saved.{p_end}
{synopt :{cmdab:output:folder(}{it:folder_path}{cmd:)}} Folder where the dta file generated by this command will be saved.{p_end}

{pstd}{it:Output options:}{p_end}
{synopt :{cmdab:sensors(}{it:string}{cmd:)}} indicates the sensor streams for which basic statistics should be calculated. Requires corresponding sensor files.{p_end}
{synopt :{cmdab:replace}} Replace the .dta file in the output folder if it already exists. Default is that only csv files in the media folder with server IDs not already in the .dta are processed and appended to the already existing file.{p_end}

{pstd}{it:Standardized Statistics options:}{p_end}
{synopt :{cmdab:quiet}} Add a statistic indicating percentage of time periods when the sound level around device was quiet. Requires SL sensor files.{p_end}
{synopt :{cmdab:still}} Add a statistic indicating percentage of time periods when the device was completely still. Requires MV sensor files.{p_end}
{synopt :{cmdab:moving}} Add a statistic indicating percentage of time periods when the device was being moved around. Requires MV sensor files.{p_end}

{pstd}{it:Customizable Statistics options:}{p_end}
{synopt :{cmdab:llbet:ween(}{it:string}{cmd:)}} Manually specified statistics for the light level stream. Requires LL sensor files.{p_end}
{synopt :{cmdab:slbet:ween(}{it:string}{cmd:)}} Manually specified statistics for the sound level stream. Requires SL sensor files.{p_end}
{synopt :{cmdab:spbet:ween(}{it:string}{cmd:)}} Manually specified statistics for the sound pitch stream. Requires SP sensor files.{p_end}
{synopt :{cmdab:mvbet:ween(}{it:string}{cmd:)}} Manually specified statistics for the movement stream. Requires MV sensor files.{p_end}

{synoptline}

{marker desc}
{title:Description}

{pstd}{cmdab:sctostreamsum} is a command that calculate statistics from the sensor stream csv files outputted by the {it:sensor_stream} field in {browse "https://www.surveycto.com/":SurveyCTO's} data collection tool. This command The csv files includes sensor data (light level, sound level, sound pitch and movement) recorded by the device used in the data collection during the interview. The unit of observation (what each row represents) in the outputted csv files is the time period the sensor data is reported on (the default is one second) but this command outputs a .dta file where the statistics have been collapsed down to one row for each submission so that the .dta file can be merged to the main data.{p_end}

{pstd}Before reading a csv file in the media folder, the command first checks if the .dta file alrady exists, and if so, if an observation with that ID already exist in the .dta file. If an observation with the same ID already exist, then the default behavior is to skip that csv file. If the option {cdm:replace} is used, then a new .dta file is generated based on all csv files in the media folder specified to be used regardless if there is a .dta file with that ID already, and if the .dta file already exist it is replaced by the new file. The only way to make changes to how statistics are calculated or add new statistics to observation already in the .dta is to use the replace option. Note that any manual edits to the .dta file done to observations in that file after they were outputted will be lost when the replace option is used.{p_end}

{pstd}The command calculates two types of statistics. {it:Basic statistics} (the mean of the sensor, the sd of the sensor, etc., full list below) that are calculated the same way for all sensors, and {it:sensor specific statistics} that are all reported as a percentage of time periods which had a mean in the sensor within a specific range. If a sensor specific statistic has been specified for a sensor, then the basic statistics will also be calculated. If no sensor specific statistic has been specified but basic statistics are still wanted, then the sensor should be listed in the {cmd:sensor()} option listed below.{p_end}

{pstd}{ul:{it:Sensor Specific statistics}}{p_end}
{pstd}The {it:sensor specific statistics} consist of {it:Standardized Statistics} where the range is predefined and {it:Customizable Statistics} where the range is specified by the user. Each of these statistics are calculated as booleans, i.e. either true or false. For example, was it quiet or not, was the sensor within a certain range or not. This true or false, represented as 1 or 0 where 1 is true, is calculated for each time period in each applicable file in the {cmdab:media:folder(}{it:folder_path}{cmd:)}. This command then calculates the percentage of time periods for which this variable was 1 and report that value in the .dta file.{p_end}

{pstd}{ul:{it:Basic statistics}}{p_end}
{pstd}The {it:basic stats} are calculated the same for all sensor streams and they are described in the table below. They are calculated for all sensor listed in {cmd:sensor()} or all sensors for which a {it:sensor specific statistics} was specified. In the .dta file they will be have the same name as in the name column below but with the sensor stream abbreviation (LL, SL, SP and MV) as a prefix.{p_end}

{p2colset 8 22 26 4}{...}
{p2col:Name}Description{p_end}
{p2line}
{p2col:mean}The mean of all time period means. In each time period there are more than one raw sensor recording. This is the mean of the time period means, not the mean of the raw recordings. The raw recordings are not with exact frequency, so it is only by making uniform time period means that all rows in the sensor stream output represents the same duration and therefore is comparable. {p_end}
{p2col:period}The sensor streams observation period length. Default if not explicitly specified in the questionnaire form definition is period=1.{p_end}
{p2col:uniform_obs}Number of uniform time period observations. As in the number of rows in the sensor stream, if period=1 then each row is a second.{p_end}
{p2col:raw_obs}Number of raw recordings. Unless the time period for the sensor stream is set to 0 in the questionnaire form, each uniform time period is made up of many sensor recordings. This is the total number of raw sensor recordings.{p_end}
{p2col:min}The minimum of all uniform time period means. Note that this is not the lowest value recorded, it is the lowest uniform time period mean.{p_end}
{p2col:max}The maximum of all uniform time period means. Note that this is not the highest value recorded, it is the highest uniform time period mean.{p_end}
{p2col:sd}The standard deviation of all uniform time period means.{p_end}
{p2col:median}The median of all uniform time period means.{p_end}
{p2line}

{marker optslong}
{title:Options}

{pstd}{it:{ul:{hi:Required options:}}}{p_end}
{phang}{cmdab:media:folder(}{it:string}{cmd:)} indicates where the csv file exported from the SurveyCTO server are saved. This is called the media folder becasue that is the name of the folder SurveyCTO Sync save these files. Other files not relevant to this commands may also be stored in this folder as this command can tell which file is sensor stream file based on the file name.{p_end}

{phang}{cmdab:output:folder(}{it:string}{cmd:)} indicates where the .dta file will be saved. This folder may not be the same folder as the folder in {cmdab:media:folder()}. If the .dta file already exists there, then only files in the media folder with an ID not already in the .dta file will be processed and appended to the already existing file, unless {cmd:replace} is used.{p_end}

{pstd}{it:{ul:{hi:Output options:}}}{p_end}
{phang}{cmdab:sensor(}{it:string}{cmd:)} lists all the sensor streams to calculate basic statistics on. If a sensor specific statistic is already specified then there is no need to also specify it here as basic statistics will also be calculated, but it will not cause an error. For each sensor listed here there must be at least one sensor stream csv file in the media folder.{p_end}

{phang}{cmdab:replace} tells the use all csv files in the {cmdab:media:folder()} (instead of first checking if they exist in the .dta file already) and calculate statistics using all of them, and replace the .dta already saved to disk (if any). This will overwrite the file already in the output folder and all manual edits after the file was originally generated will be lost. This is the only way to update observations in an already generated file using this command.{p_end}

{pstd}{it:{ul:{hi:Standardized/Off-the-Shelf/Default Statistics options:}}}{p_end}
{phang}{cmdab:quiet} adds a variable called {it:quiet} to the .dta file. This variable will be the percentage of time periods (expressed in decimals) for which the sound level was less than 25dB. An error will be generated if this option is used and no SL sensor file exist in the {cmdab:media:folder()} folder.{p_end}

{phang}{cmdab:still} adds a variable called {it:still} to the .dta file. This variable will be the percentage of time periods (expressed in decimals) for which the movement is less than 0.25 m/s^2. An error will be generated if this option is used and no MV sensor file exist in the {cmdab:media:folder()} folder.{p_end}

{phang}{cmdab:moving} adds a variable called {it:moving} to the .dta file. This variable will be the percentage of time periods (expressed in decimals) for which the movement is greater than 2 m/s^2. An error will be generated if this option is used and no MV sensor file exist in the {cmdab:media:folder()} folder.{p_end}

{pstd}{it:{ul:{hi:Customizable Statistics options:}}}{p_end}

{pstd}All of the following commands take a {inp:{it:range_string}} as value. The {it:range_string} is used to indicate the name of the new variable this command should create and the range that this command will calculate the percentage (in decimal points) of time periods that the sensor was within. Each new variable in the {it:range_string} is specified like this: {inp:{it:varname}({it:min max})}, where {it:varname} is the name of the new variable to be created, and {it:min} and {it:max} are the lower and upper boundaries for the range. Round brackets indicate that the boundary is exclusive, and straight bracket is inclusive. One of min and max can be replaced with a question mark to have a greater-than or less-than expression instead of a range. Multiple new variables can be specified in the same {it:range_string}. See examples below. {p_end}

{phang}{cmdab:llbet:ween(}{it:range_string}{cmd:)} allows the user to manually specified statistics for the light level stream. See documentation on the {it:range_string} above and examples below. of  An error will be generated if this option is used and no LL sensor file exist in the {cmdab:media:folder()} folder.{p_end}

{phang}{cmdab:slbet:ween(}{it:range_string}{cmd:)} allows the user to manually specified statistics for the sound level stream. See documentation on the {it:range_string} above and examples below. of  An error will be generated if this option is used and no SL sensor file exist in the {cmdab:media:folder()} folder.{p_end}

{phang}{cmdab:spbet:ween(}{it:range_string}{cmd:)} allows the user to manually specified statistics for the sound pitch stream. See documentation on the {it:range_string} above and examples below. of  An error will be generated if this option is used and no SP sensor file exist in the {cmdab:media:folder()} folder.{p_end}

{phang}{cmdab:mvbet:ween(}{it:range_string}{cmd:)} allows the user to manually specified statistics for the movement stream. See documentation on the {it:range_string} above and examples below. of  An error will be generated if this option is used and no MV sensor file exist in the {cmdab:media:folder()} folder.{p_end}

{pstd}{ul:range_string examples:}{p_end}

{phang}{inp:llbetween(}{it:indoors_lit(100 750)}{inp:)} will create a variable in light level stream file that is named indoors_lit with the percentage (in decimal points) of time periods where the mean light level is between 100 lux (exclusive) and 750 lux (exclusive).{p_end}

{phang}{inp:slbetween(}{it:quiet(? 25)}{inp:)} will create a variable in sound level stream files that is named quiet  percentage (in decimal points) of time periods where the mean sound level is below 25 dB (exclusive). This is identical to the variable created when using option {inp:quiet} {p_end}

{phang}{inp:mvbetween(}{it:mv1[.2 .25) mv2[1 ?]}{inp:)} will create two variables in movement stream files that is named mv1 and mv2. mv1 is the percentage (in decimal points) of time periods where the mean movement is between .2  m/s^2 (inclusive) and .25 m/s^2 (exclusive). mv2 is the percentage (in decimal points) of time periods where the mean movement is greater than 1  m/s^2 (exclusive).{p_end}

{marker examples}
{title:Examples}

{pstd}All examples will use the following globals as folder paths {p_end}

{pstd}{inp:global project "}C:\Users/username/Documents/ProjectA{inp:"}{p_end}
{pstd}{inp:global media "}$project/raw_data/media{inp:"}{p_end}
{pstd}{inp:global output "}$project/outputs{inp:"}{p_end}

{pstd} {hi:Example 1.}

{pstd} {inp:sctostreamsum, mediafolder(}{it:}"$media"{inp:) outputfolder(}{it:"$output"}{inp:) quiet still}

{pstd}This is a very simple way to run the command. The command will read sensor stream csv files in the media folder with the prefix SL (because {inp:quiet} was used) and the prefix MV (because {inp:still} was used) and add create a .dta file with the ID of all the submission in a variable called {it:key}, the basic statistics for the sound level sensor and the {it:quiet} variable, and the basic statistics for the movement sensor and the {it:still} variable and save it in the output folder. If the command has already been run and the .dta already exist in the folder, then only sumbissions with an ID not alreafy in the .dta file will be processed and appended to the already existing file. Any sensor stream files with prefix SP or LL in the media folder will be ignored as no statistic applicable to either of those streams were specified.

{pstd} {hi:Example 2.}

{pstd} {inp:sctostreamsum, mediafolder(}{it:}"$media"{inp:) outputfolder(}{it:"$output"}{inp:) quiet slbetween(}{it:loud(60 ?)}{inp:) replace}

{pstd} In this example, the command will only read SL sensor stream csv files from the media folder as SL is the only sensor for which statistics are specified. The basic statistics will be calculated for the sound level stream, in addition to the {it:quiet} and {it:loud} variables. All SL files in the media folder will be included and the command will start over with a new .dta file and replace the .dta file in the output folder if it already exist.

{title:Author}

{phang}This command is developed by {browse "https://www.surveycto.com/about/contact/":SurveyCTO}.{p_end}

{phang}GitHub{p_end}
