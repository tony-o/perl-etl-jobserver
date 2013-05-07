# job server

job server's purpose is to run jobs at regularly scheduled intervals, eventually it can be used for ad-hoc but it's not planned right now.

## job server hooks (api)

### extractors

the job server expects that an extractor can function on it's own given a few parameters.  the job server will execute the extractor with a JOBID and PSAID.  it is up to the extractor to look up the job details (table structure, source data, etc) and to fill the PSA tables.  the job server is an ass hole idiot who just tells you what to do but doesn't know himself.  so, you will receive only JOBID and PSAID.  extractors, you will store your own damn meta data in the '_META' database - you will like this or you will not use this job server because that's how we rolllllllllll


