# job server

job server's purpose is to run jobs at regularly scheduled intervals, eventually it can be used for ad-hoc but it's not planned right now.

## job server hooks (api)

### extractors

the job server expects that an extractor can function on it's own given a few parameters.  the job server will execute the extractor with a JOBID and PSAID.  it is up to the extractor to look up the job details (table structure, source data, etc) and to fill the PSA tables.  the job server is an ass hole idiot who just tells you what to do but doesn't know himself.  so, you will receive only JOBID and PSAID.  extractors, you will store your own damn meta data in the '_META' database - you will like this or you will not use this job server because that's how this works 

the job server expects to find a class name and will attempt to call 'RUN' method on that class and pass two parameters, JOBID and PSAID - the PSAID will be unique each time.  the extractor will load up **ONE** PSA table [per job] and include that PSAID as 'REQID' in the table - that is how PSA tables are distinguishable from one another.

the job server will log when what job was run and what PSAID was passed 

#### examples for weaklings

scenario: i have 2 XML feeds i need to grab and toss into some PSA

jobs (both require XML extraction):

1. weather data from your favorite weather site
2. rss feed from your favorite nerd

scheduling:
  job 1:
    1 will register with the job server providing an extractor class name, and run interval
    2 will get a jobid from job server
    3 will store my own master data related to job (column information, jobid, validation, etc)

  job 2:
    1 see job 1 steps but the jobid will be different

running:
  job 1:
    1 will be instanced by job server and forked off
    2 will pull in your bullshit weather data
    3 generate rows and fill em up with all your weather data INCLUDING REQID MAPPED TO THE PROVIDED PSAID
  
  job 2:
    1 see job 1 but will use a different PSA table in the _PSA database


