ETL-System
==========

A light-weight logging and mailing framework for ETL HIVE processes.  The goal of this project is to allow ETL scripts to run as standalone processes without strict architecture or configuration requirements.

For example, executing `test.sh`

    source etl.sh
    main()
    {
        query -f compute_the_answer_to_life_the_universe_and_everything.ql
    }
    run main

will create timestamped output logs for the main routine, individual queries, and HIVE debug output:

    log/
        test.sh/
            2012-08-20/
                hivelogs/
                    hive_job_log_pezon_201208201733_325825715.txt
                query-173300-26709.log
                test.sh-173300-26356.log

and send an e-mail with a summary of the logs with a "SUCCESS" or "FAILURE" flag.

todo
----
* Add a `--debug` flag to see query output on the screen without creating log files or sending e-mailing.
* Auto-build system to create directories that link to the etl bash script
